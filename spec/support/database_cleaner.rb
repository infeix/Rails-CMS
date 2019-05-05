# frozen_string_literal: true

require 'capybara/rspec'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
