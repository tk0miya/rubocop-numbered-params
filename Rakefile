# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: :ci

task ci: %i[rubocop spec steep]

namespace :rbs do
  desc "Install RBS signatures"
  task :install do
    sh "bundle exec rbs collection install --frozen"
  end

  desc "Generate RBS files"
  task :generate do
    sh "rbs-inline", "--opt-out", "--output=sig", "lib"
  end
end

desc "Run Steep type checker"
task steep: "rbs:install" do
  sh "bundle exec steep check"
end
