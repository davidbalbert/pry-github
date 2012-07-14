#!/usr/bin/env rake
require "bundler/gem_tasks"

direc = File.dirname(__FILE__)

PROJECT_NAME = "pry-github"

desc "run pry with plugin enabled"
task :pry do
  exec("pry -I#{direc}/lib/ -r #{direc}/lib/#{PROJECT_NAME}")
end
