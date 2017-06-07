require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  args = [
    "--app='http://localhost:#{Capybara.server_port}'",
    "--disable-internal-flash",
    "--lang=en-US"
  ]

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 60
  client.open_timeout = 60

  #profile = Selenium::WebDriver::Chrome::Profile.new
  #profile['intl.accept_languages'] = 'en'

  driver = Capybara::Selenium::Driver.new app,
    http_client: client,
    browser: :chrome,
    # profile: profile,
    args: args

  driver.browser.manage.window.resize_to(1280, 1600)

  driver
end

# ToleranceForSeleniumSyncIssues::RETRY_ERRORS << 'Selenium::WebDriver::Error::UnknownError'
