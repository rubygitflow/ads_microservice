# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'puma'
gem 'rake'

gem 'rack-unreloader', require: 'rack/unreloader'
gem 'roda', require: 'roda'

gem 'config'
gem 'i18n', require: 'i18n'

gem 'sequel'
gem 'sequel_pg', require: 'sequel'

gem 'activesupport', require: false

gem 'dry-initializer'
gem 'dry-validation'

gem 'faraday'
gem 'faraday_middleware'

gem 'bunny'

gem 'ougai', require: 'ougai'
gem 'rack-ougai', require: 'rack/ougai'
gem 'rack-request-id'

group :development do
  gem 'pry'
end

group :development, :test do
  gem 'amazing_print'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'database_cleaner-sequel'
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
end
