# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api do

  let(:api) { Typetalk::Api.new }

  describe '#access_token', :vcr do
    it 'should get access_token' do
      expect(api.instance_variable_get(:@access_token)).to be_nil

      response = api.access_token
      expect(response).to eq('(ACCESS_TOKEN)')

      expect(api.instance_variable_get(:@access_token).expire_time).to eq(Time.now.to_i + 3600)
    end


    it 'should not update access_token' do
      expect(api.instance_variable_get(:@access_token)).to be_nil

      response = api.access_token
      expect(response).to eq('(ACCESS_TOKEN)')

      response = api.access_token
      expect(response).to eq('(ACCESS_TOKEN)')
    end


    it 'should update access_token when access_token is expired' do
      expect(api.instance_variable_get(:@access_token)).to be_nil

      response = api.access_token
      expect(response).to eq('(ACCESS_TOKEN)')

      at = api.instance_variable_get(:@access_token)
      at.expire_time = Time.now.to_i # expired
      api.instance_variable_set(:@access_token, at)

      response = api.access_token
      expect(response).to eq('(UPDATED_ACCESS_TOKEN)')
    end
  end

end
