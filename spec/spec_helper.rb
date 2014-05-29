# -*- coding: utf-8 -*-
require 'bundler'
require 'vcr'
# require 'webmock/rspec'

Bundler.require


VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  #c.default_cassette_options = { :record => :none }

  c.before_record do |i|
    i.request.body.sub!(/(&?client_id=)[^&]+/, '\1(CLIENT_ID)')
    i.request.body.sub!(/(&?client_secret=)[^&]+/, '\1(CLIENT_SECRET)')
    i.request.body.sub!(/(&?refresh_token=)[^&]+/, '\1(REFRESH_TOKEN)')
    i.request.uri.sub!(/((\?|&)?access_token=)[^&]+/, '\1(ACCESS_TOKEN)')

    begin
      response = JSON.parse i.response.body
      if response.key?('access_token')
        response['access_token'] = '(ACCESS_TOKEN)'
        response['refresh_token'] = '(REFRESH_TOKEN)'
        i.response.body = response.to_json
      end
    rescue
    end
  end
end


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
