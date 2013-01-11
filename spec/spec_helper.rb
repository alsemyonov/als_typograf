SPEC_ROOT = File.expand_path('../..', __FILE__)
require 'bundler/setup'
require 'rspec'
require 'active_record'
require 'als_typograf'

Encoding.default_internal = 'utf-8'
Encoding.default_external = 'utf-8'

Dir[File.join(SPEC_ROOT, 'spec/support/**/*.rb')].each {|f| require f}

#noinspection RubyResolve
RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
