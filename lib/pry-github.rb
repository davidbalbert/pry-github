require "pry-github/version"

require 'pry'

module PryGithub
  Commands = Pry::CommandSet.new do
    create_command "gh-show", "Show GitHub page for a method" do

      def options(opt)
        method_options(opt)
      end

      def process
        puts method_object
      end
    end

    create_command "gh-blame", "Show GitHub blame page for a method" do
    end
  end

  def a_stupid_method_to_test
    s = "I am a very stupid method\n"
    s << "I wish I wasn't so stupid\n"
    s << "Oh well\n"
  end
end


Pry.commands.import PryGithub::Commands
