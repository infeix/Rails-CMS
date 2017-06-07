# frozen_string_literal: true

require 'devise'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before :suite do
    Warden.test_mode!
  end
  config.after :each do
    Warden.test_reset!
  end
end
