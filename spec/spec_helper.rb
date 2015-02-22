#spec/spec_helper.rb

# Set the rack environment to `test`
ENV["RACK_ENV"] = "test"

# Require test libraries
require 'minitest/autorun'
require 'rack/test'
require 'rack-minitest/test'
require 'faker'
require 'database_cleaner'

# Load the sinatra app
require_relative '../app'

include Rack::Test::Methods

def app
  Sinatra::Application
end
