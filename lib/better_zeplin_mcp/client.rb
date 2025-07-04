require 'net/http'
require 'json'
require 'uri'

module BetterZeplinMcp
  class Client
    BASE_URL = 'https://api.zeplin.dev/v1'
    
    def initialize(api_token = nil)
      @api_token = api_token || ENV['ZEPLIN_API_TOKEN']
      raise 'ZEPLIN_API_TOKEN is required' unless @api_token
    end
    
    def get(path, params = {})
      uri = URI.parse("#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(params) unless params.empty?
      
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{@api_token}"
      request['Accept'] = 'application/json'
      
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      
      handle_response(response)
    end
    
    private
    
    def handle_response(response)
      case response.code.to_i
      when 200..299
        JSON.parse(response.body)
      when 401
        raise "Authentication failed. Please check your API token."
      when 403
        raise "Access forbidden. You don't have permission to access this resource."
      when 404
        raise "Resource not found."
      when 429
        raise "Rate limit exceeded. Please try again later."
      else
        raise "API request failed with status #{response.code}: #{response.body}"
      end
    end
  end
end