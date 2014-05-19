# -*- coding: utf-8 -*-
require 'spec_helper'

describe Typetalk::Api::Notification do

  let(:api) { Typetalk::Api.new }

  describe '#get_notifications', :vcr do
    it 'should get the correct resource' do
      response = api.get_notifications
      expect(response).to be_a(Hashie::Mash)

      expect(response.invites.teams.size).to eq(2)
      expect(response.invites.teams[0].role).to eq('member')
      expect(response.invites.teams[0].team.name).to eq('Test Team 3')
      expect(response.invites.teams[0].sender.name).to eq('umakoz')
      expect(response.invites.teams[0].message).to eq('Test Team Invitation 3')
      expect(response.invites.teams[0].account.name).to eq('typetalk-rubygem-tester')
      expect(response.invites.teams[1].role).to eq('member')
      expect(response.invites.teams[1].team.name).to eq('Test Team 4')
      expect(response.invites.teams[1].sender.name).to eq('umakoz')
      expect(response.invites.teams[1].message).to eq('Test Team Invitation 4')
      expect(response.invites.teams[1].account.name).to eq('typetalk-rubygem-tester')

      expect(response.invites.topics.size).to eq(2)
      expect(response.invites.topics[0].topic.name).to eq('Test Topic 5')
      expect(response.invites.topics[0].sender.name).to eq('umakoz')
      expect(response.invites.topics[0].message).to eq('Test Topic Invitation 5')
      expect(response.invites.topics[0].account.name).to eq('typetalk-rubygem-tester')
      expect(response.invites.topics[1].topic.name).to eq('Test Topic 4')
      expect(response.invites.topics[1].sender.name).to eq('umakoz')
      expect(response.invites.topics[1].message).to eq('Test Topic Invitation 4')
      expect(response.invites.topics[1].account.name).to eq('typetalk-rubygem-tester')

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
  end





  describe '#get_notifications_status', :vcr do
    it 'should get the correct resource' do
      response = api.get_notifications_status
      expect(response).to be_a(Hashie::Mash)

      expect(response.access.unopened).to eq(0)
      expect(response.invite.team.pending).to eq(2)
      expect(response.invite.topic.pending).to eq(2)
      expect(response.mention.unread).to eq(1)
    end
  end





  describe '#read_notifications', :vcr do
    it 'should get the correct resource' do
      response = api.read_notifications
      expect(response).to be_a(Hashie::Mash)

      expect(response.access.unopened).to eq(0)
    end
  end





  describe '#accept_team', :vcr do
    it 'should get the correct resource' do
      response = api.accept_team(1038, 2052) # Test Team 3
      expect(response).to be_a(Hashie::Mash)

      expect(response.topics[0].name).to eq('Test Team 3')
      expect(response.invite.role).to eq('member')
      expect(response.invite.team.name).to eq('Test Team 3')
      expect(response.invite.sender.name).to eq('umakoz')
      expect(response.invite.message).to eq('Test Team Invitation 3')
      expect(response.invite.account.name).to eq('typetalk-rubygem-tester')

      # already accept team
      expect{ api.accept_team(1038, 2052) }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when team_id is wrong' do
      expect{ api.accept_team('dummy', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when invite_team_id is wrong' do
      # Test Team 3
      expect{ api.accept_team('1038', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#decline_team', :vcr do
    it 'should get the correct resource' do
      response = api.decline_team(1039, 2053) # Test Team 4
      expect(response).to be_a(Hashie::Mash)

      expect(response.role).to eq('member')
      expect(response.team.name).to eq('Test Team 4')
      expect(response.sender.name).to eq('umakoz')
      expect(response.message).to eq('Test Team Invitation 4')
      expect(response.account.name).to eq('typetalk-rubygem-tester')

      # already decline team
      expect{ api.decline_team(1039, 2053) }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when team_id is wrong' do
      expect{ api.decline_team('dummy', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when invite_team_id is wrong' do
      # Test Team 4
      expect{ api.decline_team('1039', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#accept_topic', :vcr do
    it 'should get the correct resource' do
      response = api.accept_topic(5170, 1778) # Test Topic 4
      expect(response).to be_a(Hashie::Mash)

      expect(response.invite.topic.name).to eq('Test Topic 4')
      expect(response.invite.sender.name).to eq('umakoz')
      expect(response.invite.message).to eq('Test Topic Invitation 4')
      expect(response.invite.account.name).to eq('typetalk-rubygem-tester')

      # already accept topic
      expect{ api.accept_topic(5170, 1778) }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.accept_topic('dummy', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when invite_topic_id is wrong' do
      # Test Topic 4
      expect{ api.accept_topic('5170', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end





  describe '#decline_topic', :vcr do
    it 'should get the correct resource' do
      response = api.decline_topic(5171, 1779) # Test Topic 5
      expect(response).to be_a(Hashie::Mash)

      expect(response.invite.topic.name).to eq('Test Topic 5')
      expect(response.invite.sender.name).to eq('umakoz')
      expect(response.invite.message).to eq('Test Topic Invitation 5')
      expect(response.invite.account.name).to eq('typetalk-rubygem-tester')

      # already decline topic
      expect{ api.decline_topic(5171, 1779) }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when topic_id is wrong' do
      expect{ api.decline_topic('dummy', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end


    it 'should raise error when invite_topic_id is wrong' do
      # Test Topic 5
      expect{ api.decline_topic('5171', 'dummy') }.to raise_error(Typetalk::InvalidRequest)
    end
  end

end
