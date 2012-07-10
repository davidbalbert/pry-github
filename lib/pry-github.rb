require "pry-github/version"

require 'pry'
require 'grit'
require 'launchy'

require 'uri'
require 'net/http'

module PryGithub
  module GithubHelpers
    def get_file_from_commit(path)
      git_root = find_git_root(File.dirname(path))
      repo = Grit::Repo.new(git_root)
      head = repo.commits.first
      tree_names = relative_path(git_root, path).split("/")
      start_tree = head.tree
      blob_name = tree_names.last
      tree = tree_names[0..-2].inject(start_tree)  { |a, v|  a.trees.find { |t| t.basename == v } }
      blob = tree.blobs.find { |v| v.basename == blob_name }
      blob.data
    end

    def method_code_from_head(meth)
      code = get_file_from_commit(meth.source_location.first)
      search_line = meth.source.lines.first.strip
      _, start_line = code.lines.to_a.each_with_index.find { |v, i| v.strip == search_line }

      raise "Can't find #{args[0]} in the repo. Perhaps it hasn't been committed yet." unless start_line

      start_line
      [Pry.new(:input => StringIO.new(code.lines.to_a[start_line..-1].join)).r(target), start_line + 1]
    end

    def relative_path(root, path)
      path =~ /#{root}\/(.*)/
      $1
    end

    def find_git_root(dir)
      git_root = "."
      Dir.chdir dir do
        git_root =  `git rev-parse --show-toplevel`.chomp
      end

      raise "No associated git repository found!" if git_root =~ /fatal:/
      git_root
    end

    def find_github_remote(repo)
      remote_urls = repo.remotes.map { |remote| repo.config["remote.#{remote.name.split('/')[0]}.url"] }
      gh_url = remote_urls.find { |url| url =~ /github\.com/ }

      raise "No GitHub remote found!" unless gh_url
      gh_url
    end
  end

  Commands = Pry::CommandSet.new do
    create_command "gh-show", "Show GitHub page for a method" do
      include GithubHelpers

      def options(opt)
        method_options(opt)
      end

      def process
        meth = method_object

        file_name = meth.source_location.first
        code, start_line = method_code_from_head(meth)

        git_root = find_git_root(File.dirname(file_name))

        repo = Grit::Repo.new(git_root)
        gh_url = find_github_remote(repo)

        # ssh urls can't be parsed with URI.parse
        if gh_url[0..3] == "git@"
          gh_url = gh_url.gsub(":", "/")
          gh_url[0..3] = "https://"
        end

        uri = URI.parse(gh_url)
        https_url = "https://#{uri.host}#{uri.path}".gsub(".git", "")
        https_url += "/blob/#{repo.commit("HEAD").sha}"
        https_url += file_name.gsub(repo.working_dir, '')
        https_url += "#L#{start_line}-L#{start_line + code.lines.to_a.size}"

        uri = URI.parse(https_url)
        response = nil
        Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          response = http.head(uri.path)
        end

        if response.code == "404"
          https_url = https_url.gsub(repo.commit("HEAD").sha, repo.head.name)
        end

        Launchy.open(https_url)

        binding.pry
      end
    end

    create_command "gh-blame", "Show GitHub blame page for a method" do
    end
  end
end


Pry.commands.import PryGithub::Commands
