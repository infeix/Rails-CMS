ENV["RAILS_ENV"] = "staging" if File.exists?(File.expand_path('staging.txt', __dir__))

# Load the Rails application.
require_relative 'application'
Rails.env = "staging" if File.exists?(File.expand_path('staging.txt', __dir__))

# Initialize the Rails application.
Rails.application.initialize!
