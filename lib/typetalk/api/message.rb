require 'mime/types'

module Typetalk
  class Api

    module Message

      def post_message(topic_id, message, options={})
        options = {token:nil, reply_to:nil, file_keys:nil, talk_ids:nil}.merge(options)

        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}"
          req.params[:access_token] = options[:token] || access_token
          body = {}
          body[:message] = message
          body[:replyTo] = options[:reply_to] unless options[:reply_to].nil?
          body[:showLinkMeta] = options[:show_link_meta] unless options[:show_link_meta].nil?
          body.merge! to_request_params(:fileKeys, options[:file_keys])
          body.merge! to_request_params(:talkIds, options[:talk_ids])
          req.body = body
        end
        parse_response(response)
      end


      def upload_attachment(topic_id, file, options={})
        options = {token:nil}.merge(options)

        raise InvalidFileSize if File.size(file) > 10485760 # > 10MB

        response = connection(multipart:true).post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/attachments"
          req.params[:access_token] = options[:token] || access_token
          req.body = { file: Faraday::UploadIO.new(file, MIME::Types.type_for(file).first.to_s) }
        end
        parse_response(response)
      end


      def get_message(topic_id, post_id, options={})
        options = {token:nil}.merge(options)

        response = connection.get do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end


      def remove_message(topic_id, post_id, options={})
        options = {token:nil}.merge(options)

        response = connection.delete do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
        response.status == 200
      end


      def like_message(topic_id, post_id, options={})
        options = {token:nil}.merge(options)

        response = connection.post do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}/like"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end


      def unlike_message(topic_id, post_id, options={})
        options = {token:nil}.merge(options)

        response = connection.delete do |req|
          req.url "#{endpoint}/topics/#{topic_id}/posts/#{post_id}/like"
          req.params[:access_token] = options[:token] || access_token
        end
        parse_response(response)
      end


      def read_message(topic_id, post_id=nil, options={})
        options = {token:nil}.merge(options)

        response = connection.post do |req|
          req.url "#{endpoint}/bookmark/save"
          req.params[:access_token] = options[:token] || access_token
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
