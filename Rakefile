require 'bodeco_module_helper/rake_tasks'

require 'puppet-syntax/tasks/puppet-syntax'
PuppetSyntax.exclude_paths ||= []
PuppetSyntax.exclude_paths << "spec/fixtures/**/*"
PuppetSyntax.exclude_paths << "pkg/**/*"
PuppetSyntax.exclude_paths << "vendor/**/*"

# Remove the following lines when puppet-lint is updated to a
# version > 1.1.0
require 'puppet-lint/tasks/puppet-lint'
Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ['spec/**/*.pp', 'vendor/**/*.pp', 'pkg/**/*.pp']
  config.disable_checks = ['80chars', 'arrow_alignment', 'class_parameter_defaults', 'class_inherits_from_params_class']
  PuppetLint.configuration.relative = true
end
