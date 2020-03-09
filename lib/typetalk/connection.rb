require 'faraday'

module Typetalk

  module Connection
    private

    def endpoint
      Typetalk.config.endpoint
    end

    def connection_options
      {
        :headers => {'Accept' => 'application/json; charset=utf-8', 'User-Agent' => Typetalk.config.user_agent},
        :proxy => Typetalk.config.proxy,
      }
    end

    def connection(options={})
      options = {multipart:nil}.merge(options)

      Faraday.new(connection_options) do |builder|
        builder.request :multipart if options[:multipart]
        builder.request :url_encoded
        builder.adapter :net_http
      end
    end

  end

end
