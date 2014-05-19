module Typetalk
  class Api

    module Mention

      def get_mentions(token:nil, from:nil, unread:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/mentions"
          req.params[:access_token] = token || access_token
          req.params[:from] = from unless from.nil?
          req.params[:unread] = unread unless unread.nil?
        end
        parse_response(response)
      end


      def read_mention(mention_id, token:nil)
        response = connection.put do |req|
          req.url "#{endpoint}/mentions/#{mention_id}"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end

    end

  end
end
