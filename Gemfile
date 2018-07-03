# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in jsonschema_serializer.gemspec
gemspec

gem 'rubocop', '~> 0.55.0'

group :test do
  gem 'appraisal', '~> 2.2'
  gem 'json-schema', '~> 2.8'
  gem 'simplecov', '~> 0.16'
  gem 'simplecov-console', '~> 0.4.2'
  gem 'sqlite3', platforms: :ruby
end
