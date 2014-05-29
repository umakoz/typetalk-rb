module Typetalk
  class Api

    module Auth
      attr_accessor :authorization_code

      def get_access_token(client_id:nil, client_secret:nil, grant_type:nil, scope:nil, code:nil, redirect_uri:nil)
        body = {
          client_id: client_id || Typetalk.config.client_id,
          client_secret: client_secret || Typetalk.config.client_secret,
          grant_type: grant_type || Typetalk.config.grant_type,
          scope: scope || Typetalk.config.scope,
        }

        if body[:grant_type] == 'authorization_code'
          body[:code] = code || @authorization_code
          body[:redirect_uri] = redirect_uri || Typetalk.config.redirect_uri
        end

        response = connection.post do |req|
          req.url 'https://typetalk.in/oauth2/access_token'
          req.body = body
        end
        parse_response(response)
      end


      def update_access_token(refresh_token, client_id:nil, client_secret:nil)
        body = {
          client_id: client_id || Typetalk.config.client_id,
          client_secret: client_secret || Typetalk.config.client_secret,
          grant_type: 'refresh_token',
          refresh_token: refresh_token
        }

        response = connection.post do |req|
          req.url 'https://typetalk.in/oauth2/access_token'
          req.body = body
        end
        parse_response(response)
      end


      def self.authorize_url(client_id:nil, redirect_uri:nil, scope:nil)
        params = {
          client_id: client_id || Typetalk.config.client_id,
          redirect_uri: redirect_uri || Typetalk.config.redirect_uri,
          scope: scope || Typetalk.config.scope,
          response_type: 'code',
        }
        url = URI.parse('https://typetalk.in/oauth2/authorize')
        url.query = URI.encode_www_form(params)
        url.to_s
      end

    end

  end
end
