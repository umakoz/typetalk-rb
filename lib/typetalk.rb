require "typetalk/version"
require 'typetalk/error'
require 'typetalk/api'

require 'hashie'


module Typetalk

  DEFAULT_OPTIONS = {
    client_id: ENV['TYPETALK_CLIENT_ID'],
    client_secret: ENV['TYPETALK_CLIENT_SECRET'],
    redirect_uri: nil,
    grant_type: 'client_credentials', # or 'authorization_code'
    scope: 'topic.read,topic.post,my',
    endpoint: 'https://typetalk.in/api/v1',
    proxy: nil,
    user_agent: "Typetalk Rubygem #{Typetalk::VERSION}",
  }

  class << self

    def config
      @config ||= Hashie::Mash.new(Typetalk::DEFAULT_OPTIONS)
    end

    def reset_config
      @config = nil
    end

    def configure
      yield config
    end

  end

end
