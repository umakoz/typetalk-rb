# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api::User do

  let(:api) { Typetalk::Api.new }

  describe '#get_profile', :vcr do
    it 'should get the correct resource' do
      response = api.get_profile
      expect(response).to be_a(Hashie::Mash)
      expect(response.account.name).to eq('typetalk-rubygem-tester')
      expect(response.account.fullName).to eq('Rubygem Tester')
    end

    it 'should raise error when access_token is wrong' do
      api.get_access_token
      expect{ api.get_profile(token: '(WRONG_ACCESS_TOKEN)') }.to raise_error(Typetalk::InvalidRequest)
    end

    it 'should raise error when scope is wrong' do
      r = api.get_access_token(scope: 'topic.read,topic.post')
      expect{ api.get_profile(token: r.access_token) }.to raise_error(Typetalk::InvalidRequest)
    end
  end

end
