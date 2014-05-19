require 'faraday'

module Typetalk

  module Connection
    private

    def endpoint
      Typetalk.config.endpoint
    end

    def connection_options
      {
        :headers => {'Accept' => 'application/json; charset=utf-8', 'User-Agent' => "Typetalk Rubygem #{Typetalk::VERSION}"},
        :proxy => Typetalk.config.proxy,
      }
    end

    def connection(multipart:false)
      Faraday.new(connection_options) do |conn|
        conn.request :multipart if multipart
        conn.use Faraday::Request::UrlEncoded
        conn.use Faraday::Adapter::NetHttp
        # conn.use Faraday::Response::ParseJson
        # conn.use Faraday::Response::Logger
      end
    end

  end

end
