module Typetalk
  class Api

    module Notification

      def get_notifications(token:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/notifications"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def get_notifications_status(token:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/notifications/status"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def read_notifications(token:nil)
        response = connection.put do |req|
          req.url "#{endpoint}/notifications/open"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end





      def accept_team(team_id, invite_team_id, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/teams/#{team_id}/members/invite/#{invite_team_id}/accept"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def decline_team(team_id, invite_team_id, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/teams/#{team_id}/members/invite/#{invite_team_id}/decline"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end





      def accept_topic(topic_id, invite_topic_id, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/members/invite/#{invite_topic_id}/accept"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def decline_topic(topic_id, invite_topic_id, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/members/invite/#{invite_topic_id}/decline"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end

    end

  end
end
