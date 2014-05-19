# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api::Topic do

  let(:api) { Typetalk::Api.new }
  let(:topic_id) { 5149 } # Test Topic 3

  describe '#get_topics', :vcr do
    it 'should get the correct resource' do
      response = api.get_topics
      expect(response).to be_a(Hashie::Mash)
      expect(response.topics.size).to eq(3)

      topic1 = response.topics.find {|t| t.topic.name == 'Test Topic 1'}
      expect(topic1).to be_a(Hashie::Mash)
      expect(topic1.favorite).to be true
      expect(topic1.unread['count']).to eq(1)

      topic2 = response.topics.find {|t| t.topic.name == 'Test Topic 2'}
      expect(topic2).to be_a(Hashie::Mash)
      expect(topic2.favorite).to be true
      expect(topic2.unread).to be_nil

      topic3 = response.topics.find {|t| t.topic.name == 'Test Topic 3'}
      expect(topic3).to be_a(Hashie::Mash)
      expect(topic3.favorite).to be false
      expect(topic3.unread['count']).to eq(3)
    end
  end



  describe '#get_topic', :vcr do
    it 'should get the correct resource' do
      response = api.get_topic(topic_id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.posts.size).to eq(6)

      expect(response.posts[0].topicId).to eq(topic_id)
      expect(response.posts[0].message).to eq('Test Message 3 - 1')
      expect(response.posts[0].account.name).to eq('umakoz')
      expect(response.posts[0].talks).to be_empty
      expect(response.posts[0].replyTo).to be_nil
      expect(response.posts[0].likes).to be_empty
      expect(response.posts[0].links).to be_empty
      expect(response.posts[0].mention).to be_nil
      expect(response.posts[0].attachments).to be_empty

      expect(response.posts[1].message).to eq('Test Message 3 - 2')
      expect(response.posts[1].likes).not_to be_nil

      expect(response.posts[2].message).to eq('Test Message 3 - 3')
      expect(response.posts[2].talks[0].name).to eq('Test Summary 3 - 1')

      expect(response.posts[3].message).to eq('Test Message 3 - 4')
      expect(response.posts[3].replyTo).to eq(response.posts[0].id)

      expect(response.posts[4].message).to eq('Test Message 3 - 5 @typetalk-rubygem-tester ')
      expect(response.posts[4].mention).not_to be_nil

      expect(response.posts[5].message).to eq('Test Message 3 - 6')
      expect(response.posts[5].attachments[0].fileName).to eq('logo.jpg')

      expect(response.bookmark.postId).to eq(response.posts[0].id)
      expect(response.hasNext).to be false
    end


    it 'should get the correct backward resource' do
      response = api.get_topic(topic_id, count:3, direction:'backward', from:278782) # Test Message 3 - 5
      expect(response).to be_a(Hashie::Mash)
      expect(response.posts.size).to eq(3)

      expect(response.posts[0].message).to eq('Test Message 3 - 2')
      expect(response.posts[1].message).to eq('Test Message 3 - 3')
      expect(response.posts[2].message).to eq('Test Message 3 - 4')
      expect(response.hasNext).to be true
    end


    it 'should get the correct forward resource' do
      response = api.get_topic(topic_id, count:2, direction:'forward', from:278765) # Test Message 3 - 2
      expect(response).to be_a(Hashie::Mash)
      expect(response.posts.size).to eq(2)

      expect(response.posts[0].message).to eq('Test Message 3 - 3')
      expect(response.posts[1].message).to eq('Test Message 3 - 4')
      expect(response.hasNext).to be true
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.get_topic('dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end



  describe '#get_topic_members', :vcr do
    it 'should get the correct resource' do
      response = api.get_topic_members(topic_id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.accounts.size).to eq(2)

      account1 = response.accounts.find {|a| a.account.name == 'typetalk-rubygem-tester'}
      expect(account1).not_to be_nil
      account2 = response.accounts.find {|a| a.account.name == 'umakoz'}
      expect(account2).not_to be_nil
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.get_topic_members('dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end



  describe '#favorite_topic', :vcr do
    it 'should get the correct resource' do
      response = api.favorite_topic(topic_id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.id).to eq(topic_id)
      expect(response.name).to eq('Test Topic 3')
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.favorite_topic('dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end



  describe '#unfavorite_topic', :vcr do
    it 'should get the correct resource' do
      response = api.unfavorite_topic(topic_id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.id).to eq(topic_id)
      expect(response.name).to eq('Test Topic 3')
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.unfavorite_topic('dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end

end
