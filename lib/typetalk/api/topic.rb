module Typetalk
  class Api

    module Topic

      def get_topics(token:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/topics"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def get_topic(topic_id, token:nil, count:nil, from:nil, direction:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/topics/#{topic_id}"
          req.params[:access_token] = token || access_token
          req.params[:count] = count unless count.nil?
          req.params[:from] = from unless from.nil?
          req.params[:direction] = direction unless direction.nil?
        end
        parse_response(response)
      end


      def get_topic_members(topic_id, token:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/topics/#{topic_id}/members/status"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def favorite_topic(topic_id, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/favorite"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def unfavorite_topic(topic_id, token:nil)
        response = connection.delete do |req|
          req.url "#{endpoint}/topics/#{topic_id}/favorite"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end

    end

  end
end
