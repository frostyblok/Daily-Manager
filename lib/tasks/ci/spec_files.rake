require "rspec/core/rake_task"
require "ci/split_tests"

namespace :spec do
  RSpec::Core::RakeTask.new(:sliced, [:index, :concurrency]) do |t, args|
    tests = SplitTests.new(index: args[:index],
                           concurrency: args[:concurrency]).split
    t.pattern = tests
  end
end
