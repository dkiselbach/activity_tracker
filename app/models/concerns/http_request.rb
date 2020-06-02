module HttpRequest
  extend ActiveSupport::Concern

  def post(url, body, token=nil)

    uri = URI.parse(url)

    request = Net::HTTP::Post.new(uri)
    request.set_form_data(body)
    if token
      request["Authorization"] = "Bearer #{token}"
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if 'https' == uri.scheme

    @response = http.request(request)

    if @response.code == '200'
      @success = JSON.parse(@response.body)
    elsif @response.code == '429'
      raise ApiExceptions::RateLimitError.new()
    else
      @error = "HTTP #{@response.code}: #{@response.body}"
    end
  end

  def get(url, token=nil)

    uri = URI.parse(url)

    request = Net::HTTP::Get.new(uri)
    if token
      request["Authorization"] = "Bearer #{token}"
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if 'https' == uri.scheme

    @response = http.request(request)

    if @response.code == '200'
      @success = JSON.parse(@response.body)
    elsif @response.code == '429'
      raise ApiExceptions::RateLimitError.new()
    else
      @error = "HTTP #{@response.code}: #{@response.body}"
    end
  end
end
