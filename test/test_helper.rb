ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
require 'webmock/minitest'
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }
Minitest::Reporters.use!
WebMock.disable_net_connect!

ENV['STRAVA_SITE_BASE']='https://www.strava.com'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  fixtures :all
  include Devise::Test::IntegrationHelpers
end

class ActionDispatch::IntegrationTest
  include HttpRequestHelper
end
