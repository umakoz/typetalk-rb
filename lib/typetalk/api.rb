require 'typetalk/connection'

module Typetalk

  class Api
    include Connection

    Dir[File.join(__dir__, 'api/*.rb')].each{|f| require f}
    include Auth
    include User
    include Topic
    include Message
    include Mention
    include Notification


    def access_token
      @access_token ||= get_access_token
      @access_token['access_token']
    end


    protected
    def parse_response(response)

      # TODO remove debug print
      #require 'awesome_print'
      #ap response

      case response.status
      when 400, 401
        raise InvalidRequest, response_values(response)
      when 404
        raise NotFound, response_values(response)
      when 413
        raise InvalidFileSize, response_values(response)
      end

      body = JSON.parse(response.body) rescue response.body
      body.is_a?(Hash) ? Hashie::Mash.new(body) : body
    end

    def response_values(response)
      {status: response.status, headers: response.headers, body: response.body}
    end

  end

end
