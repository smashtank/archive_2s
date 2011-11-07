require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake'
require 'rspec/core/rake_task'

desc "Run all specs."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts =  %q[--exclude "spec,gems" --include-file "lib/archive_2s"]
  t.verbose = true
end