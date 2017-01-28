#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

test_rake_task =
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.test_files = FileList['test/*_test.rb']
  test.verbose = true
end

desc test_rake_task.description
task :default => :test