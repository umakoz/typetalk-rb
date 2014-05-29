module Typetalk
  class Api

    module Topic

      def get_topics(options={})
        options = {token:nil}.merge(options)

        response = connection.get do |req|
          req.url "#{endpoint}/topics"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end


      def get_topic(topic_id, options={})
        options = {token:nil, count:nil, from:nil, direction:nil}.merge(options)

        response = connection.get do |req|
          req.url "#{endpoint}/topics/#{topic_id}"
          req.params[:access_token] = options[:token] || access_token
          req.params[:count] = options[:count] unless options[:count].nil?
          req.params[:from] = options[:from] unless options[:from].nil?
          req.params[:direction] = options[:direction] unless options[:direction].nil?
        end
        parse_response(response)
      end


      def get_topic_members(topic_id, options={})
        options = {token:nil}.merge(options)

        response = connection.get do |req|
          req.url "#{endpoint}/topics/#{topic_id}/members/status"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end


      def favorite_topic(topic_id, options={})
        options = {token:nil}.merge(options)

        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/favorite"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end


      def unfavorite_topic(topic_id, options={})
        options = {token:nil}.merge(options)

        response = connection.delete do |req|
          req.url "#{endpoint}/topics/#{topic_id}/favorite"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end

    end

  end
end
