# staging if staging.txt file exists
ENV["RAILS_ENV"] = "staging" if File.exists?(File.expand_path('staging.txt', __dir__))

require_relative 'application'

# staging if staging.txt file exists
Rails.env = "staging" if File.exists?(File.expand_path('staging.txt', __dir__))# Load the Rails application.

# Initialize the Rails application.
Rails.application.initialize!
