# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api::Mention do

  let(:api) { Typetalk::Api.new }

  describe '#get_mentions', :vcr do
    it 'should get the correct resource' do
      response = api.get_mentions
      expect(response).to be_a(Hashie::Mash)

      expect(response.mentions.size).to eq(3)
      expect(response.mentions[0].post.message).to eq('Test Message 1 - 4 @typetalk-rubygem-tester ')
      expect(response.mentions[0].post.topic.name).to eq('Test Topic 1')
      expect(response.mentions[0].post.account.name).to eq('umakoz')
      expect(response.mentions[1].post.message).to eq('Test Message 1 - 3 @typetalk-rubygem-tester ')
      expect(response.mentions[1].post.topic.name).to eq('Test Topic 1')
      expect(response.mentions[1].post.account.name).to eq('umakoz')
      expect(response.mentions[2].post.message).to eq('Test Message 3 - 5 @typetalk-rubygem-tester ')
      expect(response.mentions[2].post.topic.name).to eq('Test Topic 3')
      expect(response.mentions[2].post.account.name).to eq('umakoz')
    end


    it 'should get the correct resource till mention' do
      response = api.get_mentions(from:36069) # Test Message 1 - 4 @typetalk-rubygem-tester 
      expect(response).to be_a(Hashie::Mash)

      expect(response.mentions.size).to eq(2)
      expect(response.mentions[0].post.message).to eq('Test Message 1 - 3 @typetalk-rubygem-tester ')
      expect(response.mentions[0].post.topic.name).to eq('Test Topic 1')
      expect(response.mentions[0].post.account.name).to eq('umakoz')
      expect(response.mentions[1].post.message).to eq('Test Message 3 - 5 @typetalk-rubygem-tester ')
      expect(response.mentions[1].post.topic.name).to eq('Test Topic 3')
      expect(response.mentions[1].post.account.name).to eq('umakoz')
    end


    it 'should get the unread resource' do
      response = api.get_mentions(unread:true)
      expect(response).to be_a(Hashie::Mash)

      expect(response.mentions.size).to eq(2)
      expect(response.mentions[0].post.message).to eq('Test Message 1 - 4 @typetalk-rubygem-tester ')
      expect(response.mentions[0].post.topic.name).to eq('Test Topic 1')
      expect(response.mentions[0].post.account.name).to eq('umakoz')
      expect(response.mentions[1].post.message).to eq('Test Message 3 - 5 @typetalk-rubygem-tester ')
      expect(response.mentions[1].post.topic.name).to eq('Test Topic 3')
      expect(response.mentions[1].post.account.name).to eq('umakoz')
    end
  end





  describe '#read_mention', :vcr do
    it 'should get the correct resource' do
      response = api.read_mention(36069)
      expect(response).to be_a(Hashie::Mash)

      expect(response.mention.post.message).to eq('Test Message 1 - 4 @typetalk-rubygem-tester ')
      expect(response.mention.post.topic.name).to eq('Test Topic 1')
      expect(response.mention.post.account.name).to eq('umakoz')
    end

    it 'should raise error when mention_id is wrong' do
      expect{ api.read_mention('dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end

end
