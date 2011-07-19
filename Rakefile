#!/usr/bin/env rake

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new do |task|
    task.files   = ['lib/**/*.rb']
    task.options = [
      '--protected',
      '--output-dir', 'doc/yard',
      '--markup', 'markdown',
      '--readme', 'Readme.md'
    ]
  end
end