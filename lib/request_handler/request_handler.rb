# frozen_string_literal: true

require 'net/http'

class RequestHander
  class << self
    def request(uri)
      url = URI.parse(uri)
      req = Net::HTTP::Get.new(url.request_uri)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      response = http.request(req)

      result = JSON.parse(response.body)
      return result.symbolize_keys unless result.is_a?(Array)

      result
    end
  end
end
