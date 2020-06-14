require 'test_helper'

class UrlHelperTest < ActionView::TestCase
  test "url builder should contruct proper url" do
    @token = 123456
    url = url_builder(:example_token => @token)
    assert_equal "#{ENV["SITE_BASE"]}?example_token=#{@token}", url
  end
end
