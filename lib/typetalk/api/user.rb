module Typetalk
  class Api

    module User

      def get_profile(token:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/profile"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end

    end

  end
end
