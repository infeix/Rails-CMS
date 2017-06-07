# frozen_string_literal: true

require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    inspector: false,
    js_errors: true,
    timeout: 180,
    port: 44678 + ENV['TEST_ENV_NUMBER'].to_i,
    window_size: [1280, 1600],
    phantomjs_options: [
      '--load-images=yes',
      '--web-security=false',
      '--proxy-type=none',
      '--ignore-ssl-errors=yes'
    ]
  )
end
