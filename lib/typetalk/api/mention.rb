module Typetalk
  class Api

    module Mention

      def get_mentions(options={})
        options = {token:nil, from:nil, unread:nil}.merge(options)

        response = connection.get do |req|
          req.url "#{endpoint}/mentions"
          req.params[:access_token] = options[:token] || access_token
          req.params[:from] = options[:from] unless options[:from].nil?
          req.params[:unread] = options[:unread] unless options[:unread].nil?
        end
        parse_response(response)
      end


      def read_mention(mention_id, options={})
        options = {token:nil}.merge(options)

        response = connection.put do |req|
          req.url "#{endpoint}/mentions/#{mention_id}"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end

    end

  end
end
