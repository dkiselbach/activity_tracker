# frozen_string_literal: true

module HttpRequest
  extend ActiveSupport::Concern

  def post(url, body, token = nil)
    uri = URI.parse(url)

    request = Net::HTTP::Post.new(uri)
    request.set_form_data(body)
    request['Authorization'] = "Bearer #{token}" if token

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'

    @response = http.request(request)

    if @response.code == '200'
      @success = JSON.parse(@response.body)
    elsif @response.code == '429'
      raise ApiExceptions::RateLimitError
    elsif @response.code == '400'
      false
    elsif @response.code == '401'
      raise ApiExceptions::AuthenticationError
    else
      @error = "HTTP #{@response.code}: #{@response.body}"
      raise ApiExceptions::InvalidRequestError, @error
    end
  end

  def put(url, body, token = nil)
    uri = URI.parse(url)

    request = Net::HTTP::Put.new(uri)
    request.set_form_data(body)
    request['Authorization'] = "Bearer #{token}" if token

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'

    @response = http.request(request)

    if @response.code == '200'
      @success = JSON.parse(@response.body)
    elsif @response.code == '429'
      raise ApiExceptions::RateLimitError
    elsif @response.code == '400'
      false
    elsif @response.code == '401'
      raise ApiExceptions::AuthenticationError
    else
      @error = "HTTP #{@response.code}: #{@response.body}"
      raise ApiExceptions::InvalidRequestError, @error
    end
  end

  def get(url, token = nil)
    uri = URI.parse(url)

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{token}" if token

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'

    @response = http.request(request)

    if @response.code == '200'
      @success = JSON.parse(@response.body)
    elsif @response.code == '429'
      raise ApiExceptions::RateLimitError
    elsif @response.code == '401'
      raise ApiExceptions::AuthenticationError
    else
      @error = "HTTP #{@response.code}: #{@response.body}"
      raise ApiExceptions::InvalidRequestError, @error
    end
  end
end
