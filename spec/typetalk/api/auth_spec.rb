# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api::Auth do

  let(:api) { Typetalk::Api.new }

  describe '#get_access_token', :vcr do
    it 'should get the correct resource by client_credentials' do
      response = api.get_access_token
      expect(response).to be_a(Hashie::Mash)
      expect(response.access_token).to eq('(ACCESS_TOKEN)')
      expect(response.refresh_token).to eq('(REFRESH_TOKEN)')
      expect(response.scope).to eq('topic.read,topic.post,my')
      expect(response.token_type).to eq('Bearer')
      expect(response.expires_in).to eq(3600)
    end

    it 'should get the correct resource by client_credentials when scope changed' do
      response = api.get_access_token(scope: 'my')
      expect(response).to be_a(Hashie::Mash)
      expect(response.access_token).to eq('(ACCESS_TOKEN)')
      expect(response.refresh_token).to eq('(REFRESH_TOKEN)')
      expect(response.scope).to eq('my')
    end

    it 'should raise error when client_id is wrong' do
      expect{ api.get_access_token(client_id: 'dummy_id') }.to raise_error(Typetalk::InvalidRequest)
    end

    it 'should raise error when client_secret is wrong' do
      expect{ api.get_access_token(client_secret: 'dummy_secret') }.to raise_error(Typetalk::InvalidRequest)
    end

    it 'should get the correct resource by authorization_code' do
      api.authorization_code = '(AUTHORIZATION_CODE)'
      response = api.get_access_token(grant_type: 'authorization_code', redirect_uri: 'http://dummy/')
      expect(response).to be_a(Hashie::Mash)
      expect(response.access_token).to eq('(ACCESS_TOKEN)')
      expect(response.refresh_token).to eq('(REFRESH_TOKEN)')
      expect(response.scope).to eq('topic.read,topic.post,my')
      expect(response.token_type).to eq('Bearer')
      expect(response.expires_in).to eq(3600)
    end

    it 'should raise error when redirect_uri mismatch' do
      api.authorization_code = '(AUTHORIZATION_CODE)'
      expect{ api.get_access_token(grant_type: 'authorization_code', redirect_uri: 'http://dummy_mismatch/') }.to raise_error(Typetalk::InvalidRequest)
    end

    it 'should raise error when authorization_code is wrong' do
      expect{ api.get_access_token(grant_type: 'authorization_code', redirect_uri: 'http://dummy/', code:'dummy_code') }.to raise_error(Typetalk::InvalidRequest)
    end
  end



  describe '.authorize_url' do
    before do
      Typetalk.configure do |config|
        config.client_id = 'dummy_id'
        config.redirect_uri = 'http://dummy/'
        config.scope = 'topic.read,topic.write'
      end
    end
    after { Typetalk.reset_config }

    it 'should get the correct url' do
      url = URI.parse(Typetalk::Api::Auth.authorize_url)
      query = Hash[URI.decode_www_form(url.query)]
      expect(url.scheme).to eq('https')
      expect(url.host).to eq('typetalk.in')
      expect(url.path).to eq('/oauth2/authorize')
      expect(query['client_id']).to eq('dummy_id')
      expect(query['redirect_uri']).to eq('http://dummy/')
      expect(query['response_type']).to eq('code')
      expect(query['scope']).to eq('topic.read,topic.write')
    end
  end

end
