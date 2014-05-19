require 'mime/types'

module Typetalk
  class Api

    module Message

      def post_message(topic_id, message, token:nil, reply_to:nil, file_keys:nil, talk_ids:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}"
          req.params[:access_token] = token || access_token
          body = {}
          body[:message] = message
          body[:replyTo] = reply_to unless reply_to.nil?
          body.merge! to_request_params('fileKeys', file_keys)
          body.merge! to_request_params('talkIds', talk_ids)
          req.body = body
        end
        parse_response(response)
      end


      def upload_attachment(topic_id, file, token:nil)
        raise InvalidFileSize if File.size(file) > 10485760 # > 10MB

        response = connection(multipart:true).post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/attachments"
          req.params[:access_token] = token || access_token
          req.body = { file: Faraday::UploadIO.new(file, MIME::Types.type_for(file).first.to_s) }
        end
        parse_response(response)
      end


      def get_message(topic_id, post_id, token:nil)
        response = connection.get do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def remove_message(topic_id, post_id, token:nil)
        response = connection.delete do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
        response.status == 200
      end


      def like_message(topic_id, post_id, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}/like"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def unlike_message(topic_id, post_id, token:nil)
        response = connection.delete do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}/like"
          req.params[:access_token] = token || access_token
        end
        parse_response(response)
      end


      def read_message(topic_id, post_id=nil, token:nil)
        response = connection.post do |req|
          req.url "#{endpoint}/bookmark/save"
          req.params[:access_token] = token || access_token
          body = {}
          body[:topicId] = topic_id
          body[:postId] = post_id unless post_id.nil?
          req.body = body
        end
        parse_response(response)
      end



      private
      def to_request_params(key, values)
        params = {}
        unless values.nil?
          if values.is_a?(Array)
            values.each_with_index do |k, i|
              break if i > 4
              params["#{key}[#{i}]"] = k.to_s
            end
          else
            params["#{key}[0]"] = values.to_s
          end
        end
        params
      end

    end

  end
end
