# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
require 'webmock/minitest'
require 'devise/jwt/test_helpers'
Dir[Rails.root.join('test/support/**/*.rb')].sort.each { |f| require f }
Minitest::Reporters.use!
WebMock.disable_net_connect!

ENV['STRAVA_SITE_BASE'] = 'https://www.strava.com'
ENV['STRAVA_SCOPE'] = 'read,read_all,profile:read_all,profile:write,activity:read_all'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  fixtures :all
  include DeviseJwtHelper
  include Devise::JWT::TestHelpers
  include StravaAuthStubs
  include StravaActivitiesStubs
  include StravaThrottledStubs
  include JSONFixtures
end

class ActionDispatch::IntegrationTest
  include DeviseJwtHelper
  include Devise::JWT::TestHelpers
  include StravaAuthStubs
  include StravaActivitiesStubs
  include StravaThrottledStubs
  include JSONFixtures
end
