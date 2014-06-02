require 'typetalk/connection'

module Typetalk

  class Api
    include Connection

    Dir[File.join(File.dirname(__FILE__), 'api/*.rb')].each{|f| require f}
    include Auth
    include User
    include Topic
    include Message
    include Mention
    include Notification


    def access_token
      if @access_token.nil?
        @access_token = get_access_token
        @access_token.expire_time = Time.now.to_i + @access_token.expires_in.to_i
      elsif Time.now.to_i >= @access_token.expire_time
        @access_token = update_access_token(@access_token.refresh_token)
        @access_token.expire_time = Time.now.to_i + @access_token.expires_in.to_i
      end
      @access_token.access_token
    end


    protected
    def parse_response(response)

      # TODO remove debug print
      #require 'awesome_print'
      #ap response

      case response.status
      when 400
        raise InvalidRequest, response_values(response)
      when 401
        raise Unauthorized, response_values(response)
      when 404
        raise NotFound, response_values(response)
      when 413
        raise InvalidFileSize, response_values(response)
      end

      body = JSON.parse(response.body) rescue response.body
      body.is_a?(Hash) ? Hashie::Mash.new(body) : body
    end

    def response_values(response)
      {status: response.status, headers: response.headers, body: response.body}.to_json
    end

  end

end
