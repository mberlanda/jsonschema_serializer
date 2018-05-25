# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

if ENV['RAILS_ENV'] == 'test'
  require File.expand_path('dummy/config/environment', __dir__)
  require 'rspec/rails'

  ActiveRecord::Migration.maintain_test_schema!

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_spec_type_from_file_location!
    config.filter_rails_from_backtrace!
  end
end
