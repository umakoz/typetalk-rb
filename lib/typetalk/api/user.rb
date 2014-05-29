module Typetalk
  class Api

    module User

      def get_profile(options={})
        options = {token:nil}.merge(options)

        response = connection.get do |req|
          req.url "#{endpoint}/profile"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end

    end

  end
end
