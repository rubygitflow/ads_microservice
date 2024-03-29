# frozen_string_literal: true

require 'database_cleaner-sequel'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end
