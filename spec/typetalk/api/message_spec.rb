# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api::Message do

  let(:api) { Typetalk::Api.new }
  let(:topic_id) { 5148 } # Test Topic 2

  describe '#post_message', :vcr do
    it 'should get the correct resource' do
      response = api.post_message(topic_id, 'Test Message 2 - 1')
      expect(response).to be_a(Hashie::Mash)
      expect(response.topic.name).to eq('Test Topic 2')
      expect(response.post.message).to eq('Test Message 2 - 1')
      expect(response.post.account.name).to eq('typetalk-rubygem-tester')
      expect(response.post.replyTo).to be_nil
      expect(response.post.talks).to be_empty
      expect(response.post.attachments).to be_empty
    end


    it 'should get the correct resource for reply' do
      response1 = api.post_message(topic_id, 'Test Message 2 - 2')
      expect(response1).to be_a(Hashie::Mash)
      expect(response1.post.message).to eq('Test Message 2 - 2')
      expect(response1.post.replyTo).to be_nil

      response2 = api.post_message(topic_id, 'Test Message 2 - 3', reply_to:response1.post.id)
      expect(response2).to be_a(Hashie::Mash)
      expect(response2.post.message).to eq('Test Message 2 - 3')
      expect(response2.post.replyTo).to eq(response1.post.id)
    end


    it 'should get the correct resource for attachments' do
      attachment1 = api.upload_attachment(topic_id, File.join(File.dirname(__FILE__), '../../fixtures/attachments/logo_typetalk.jpg'))
      attachment2 = api.upload_attachment(topic_id, File.join(File.dirname(__FILE__), '../../fixtures/attachments/logo_cacoo.jpg'))
      response = api.post_message(topic_id, 'Test Message 2 - 4', file_keys:[attachment1.fileKey, attachment2.fileKey])
      expect(response).to be_a(Hashie::Mash)
      expect(response.post.message).to eq('Test Message 2 - 4')

      a1 = response.post.attachments.find {|a| a.fileName == 'logo_typetalk.jpg'}
      expect(a1).not_to be_nil
      a2 = response.post.attachments.find {|a| a.fileName == 'logo_cacoo.jpg'}
      expect(a2).not_to be_nil
    end


    it 'should get the correct resource for talks' do
      response = api.post_message(topic_id, 'Test Message 2 - 5', talk_ids:[3993, 3994, 3995]) # 'Test Summary 2 - 1', 'Test Summary 2 - 2', 'Test Summary 2 - 3'
      expect(response).to be_a(Hashie::Mash)
      expect(response.post.message).to eq('Test Message 2 - 5')

      talk1 = response.post.talks.find {|t| t.name == 'Test Summary 2 - 1'}
      expect(talk1).not_to be_nil
      talk2 = response.post.talks.find {|t| t.name == 'Test Summary 2 - 2'}
      expect(talk2).not_to be_nil
      talk3 = response.post.talks.find {|t| t.name == 'Test Summary 2 - 3'}
      expect(talk3).not_to be_nil
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.post_message('dummy', 'Test Message Dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#upload_attachment', :vcr do
    it 'should get the correct resource' do
      response = api.upload_attachment(topic_id, File.join(File.dirname(__FILE__), '../../fixtures/attachments/logo_typetalk.jpg'))
      expect(response).to be_a(Hashie::Mash)
      expect(response.fileName).to eq('logo_typetalk.jpg')
      expect(response.fileSize).to eq(7622)
      expect(response.fileKey).not_to be_nil
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.upload_attachment('dummy', File.join(File.dirname(__FILE__), '../../fixtures/attachments/logo_typetalk.jpg')) }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when file size 10MB', vcr:false do
      file = File.join(File.dirname(__FILE__), '../../fixtures/attachments/10mb.txt')
      File.write(file, 'a' * (10485760 + 1))
      expect{ api.upload_attachment(topic_id, file) }.to raise_error(Typetalk::InvalidFileSize)
      File.unlink(file)
    end
  end





  describe '#get_message', :vcr do
    it 'should get the correct resource' do
      message = api.post_message(topic_id, 'Test Message 2 - 6')
      response = api.get_message(topic_id, message.post.id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.topic.name).to eq('Test Topic 2')
      expect(response.post.message).to eq('Test Message 2 - 6')
      expect(response.post.account.name).to eq('typetalk-rubygem-tester')
      expect(response.post.replyTo).to be_nil
      expect(response.post.talks).to be_empty
      expect(response.post.attachments).to be_empty
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.get_message('dummy', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when post_id is wrong' do
      expect{ api.get_message(topic_id, 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#remove_message', :vcr do
    it 'should get the correct resource' do
      message = api.post_message(topic_id, 'Test Message 2 - 7')

      response = api.get_message(topic_id, message.post.id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.post.message).to eq('Test Message 2 - 7')

      response = api.remove_message(topic_id, message.post.id)
      expect(response).to be true

      expect{ api.get_message(topic_id, message.post.id) }.to raise_error(Typetalk::NotFound)
    end


    it 'should raise error when post_id is wrong' do
      expect{ api.remove_message(topic_id, 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#like_message', :vcr do
    it 'should get the correct resource' do
      message = api.post_message(topic_id, 'Test Message 2 - 8')

      response = api.like_message(topic_id, message.post.id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.like.topicId).to eq(topic_id)
      expect(response.like.postId).to eq(message.post.id)
      expect(response.like.account.name).to eq('typetalk-rubygem-tester')

      # when already liked
      expect { api.like_message(topic_id, message.post.id) }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when post_id is wrong' do
      expect{ api.like_message(topic_id, 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#unlike_message', :vcr do
    it 'should get the correct resource' do
      message = api.post_message(topic_id, 'Test Message 2 - 9')

      # when unliked
      expect { api.unlike_message(topic_id, message.post.id) }.to raise_error(Typetalk::NotFound)

      liked = api.like_message(topic_id, message.post.id)

      response = api.unlike_message(topic_id, message.post.id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.like.topicId).to eq(topic_id)
      expect(response.like.postId).to eq(message.post.id)
      expect(response.like.id).to eq(liked.like.id)
      expect(response.like.account.name).to eq('typetalk-rubygem-tester')
    end


    it 'should raise error when post_id is wrong' do
      expect{ api.unlike_message(topic_id, 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#read_message', :vcr do
    it 'should get the correct resource' do
      message1 = api.post_message(topic_id, 'Test Message 2 - 10')
      message2 = api.post_message(topic_id, 'Test Message 2 - 11')

      response = api.read_message(topic_id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.unread.topicId).to eq(topic_id)
      expect(response.unread.postId).to eq(message2.post.id)
      expect(response.unread["count"]).to eq(0)
    end


    it 'should get the correct resource till post' do
      message1 = api.post_message(topic_id, 'Test Message 2 - 12')
      message2 = api.post_message(topic_id, 'Test Message 2 - 13')

      response = api.read_message(topic_id, message1.post.id)
      expect(response).to be_a(Hashie::Mash)
      expect(response.unread.topicId).to eq(topic_id)
      expect(response.unread.postId).to eq(message1.post.id)
      expect(response.unread["count"]).to eq(1)
    end


    it 'should raise error when post_id is wrong' do
      expect{ api.read_message(topic_id, 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end

end
