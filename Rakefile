require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Run all specs."
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = %w(--format NyanCatFormatter)
end
task default: :spec
