require "drip/response"
require "drip/client/subscribers"
require "drip/client/tags"
require "drip/client/events"
require "faraday"
require "faraday_middleware"
require "json"

module Drip
  class Client
    include Subscribers
    include Tags
    include Events

    attr_accessor :access_token, :api_key, :account_id

    def initialize
      yield(self) if block_given?
    end

    def generate_resource(key, *args)
      { key => args }
    end

    def content_type
      'application/vnd.api+json'
    end

    def get(url, options = {})
      build_response do
        connection.get do |req|
          req.url url
          req.params = options
        end
      end
    end

    def post(url, options = {})
      build_response do
        connection.post do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def put(url, options = {})
      build_response do
        connection.put do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def delete(url, options = {})
      build_response do
        connection.delete do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def build_response(&block)
      response = yield
      Drip::Response.new(response.status, response.body)
    end

    def connection
      @connection ||= initialize_connection
    end

    def initialize_connection
      conn ||= Faraday.new(url: "https://api.getdrip.com/v2/") do |f|
        f.adapter :net_http
        f.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      end

      conn.headers['Content-Type'] = content_type
      conn.headers['Accept'] = "*/*"

      if access_token
        conn.headers['Authorization'] = "Bearer #{access_token}"
      else
        conn.basic_auth api_key, ""
      end

      conn
    end
  end
end
