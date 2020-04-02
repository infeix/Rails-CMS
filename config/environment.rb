# staging if staging.txt file exists
ENV["RAILS_ENV"] = "staging" if File.exists?(File.expand_path('staging.txt', __dir__))

require File.expand_path('../application', __FILE__)
require File.expand_path('../rollbar', __FILE__)

# staging if staging.txt file exists
Rails.env = "staging" if File.exists?(File.expand_path('staging.txt', __dir__))# Load the Rails application.

notify = ->(e) do
  begin
    Rollbar.with_config(use_async: false) do
      Rollbar.error(e)
    end
  rescue
    Rails.logger.error "Synchronous Rollbar notification failed.  Sending async to preserve info"
    Rollbar.error(e)
  end
end

begin
  Rails.application.initialize!
rescue Exception => e
  notify.(e)
  raise
end
