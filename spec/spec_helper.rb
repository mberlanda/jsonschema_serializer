# frozen_string_literal: true

require 'bundler/setup'
require 'json-schema'
require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

require 'jsonschema_serializer'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Skip rails tests on jruby
  config.exclude_pattern = '**/dummy_specs/**/*' if ENV['SKIP_RAILS']
end
