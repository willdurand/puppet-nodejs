require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop_local) do |t|
  t.options = ['-c', '.rubocop.yml']
end

PuppetLint.configuration.log_format       = "%{path}:%{line}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = false
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_arrow_on_right_operand_line")

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths            = exclude_paths

desc "Run acceptance with beaker"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc "Run syntax, lint, spec and acceptance tests."
task :test => [
  :metadata_lint,
  :rubocop_local,
  :syntax,
  :lint,
  :spec,
]
