# Typetalk

A Ruby wrapper for [Typetalk API](http://developers.typetalk.in/api.html). The Typetalk gem provides an easy-to-use wrapper for Typetalk's REST APIs.





## Installation

Add this line to your application's Gemfile:

    gem 'typetalk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install typetalk





## Configuration

You need to provide your Client ID and Client Secret.

    Typetalk.configure do |config|
      config.client_id = '...'
      config.client_secret = '...'
      # option
      config.scope = 'topic.read,topic.post,my'
      config.grant_type = 'client_credentials' # or 'authorization_code'
      config.redirect_uri = '...' # for authorization code
      config.proxy = '...'
    end

You can also specify these values via ENV:

    export TYPETALK_CLIENT_ID='...'
    export TYPETALK_CLIENT_SECRET='...'





## Usage

### Authetication

It is usually not necessary if there is a configuration, because it automatically acquires.

    require 'rubygems'
    require 'typetalk'
    
    api = Typetalk::Api.new
    
    # Get access token using client credentials
    response = api.get_access_token(scope: 'my')
    access_token = response.access_token



### Profile

    # api is a Typetalk::Api
    
    # Get my profile
    response = api.get_profile
    my_name = response.account.name
    my_full_name = response.account.fullName



### Topics

    # api is a Typetalk::Api
    
    # Get my topics
    response = api.get_topics
    topic_id = response.topics[0].topic.id
    topic_name = response.topics[0].topic.name
    
    # Get topic messages
    topic = api.get_topic(topic_id)
    post_id = topic.posts[0].id
    message_text = topic.posts[0].message
    sender = topic.posts[0].account.name
    
    # Get topic members
    members = api.get_topic_members(topic_id)
    member_id = members.accounts[0].account.id
    member_name = members.accounts[0].account.name
    
    # Favorite topic
    api.favorite_topic(topic_id)
    
    # unfavorite topic
    api.unfavorite_topic(topic_id)



### Message

    # api is a Typetalk::Api
    
    # Post message
    api.post_message(topic_id, 'message text')
    
    # Post message with attachment
    attachment = api.upload_attachment(topic_id, '/path/to/attachment.jpg')
    response = api.post_message(topic_id, 'message text', file_keys:[attachment.fileKey])
    
    # Get message
    message = api.get_message(topic_id, response.post.id)
    message_text = message.post.message
    sender = message.post.account.name
    
    # Like message
    api.like_message(topic_id, post_id)
    
    # Unlike message
    api.unlike_message(topic_id, post_id)
    
    # Read message
    api.read_message(topic_id, post_id)
    
    # Read all messages
    api.read_message(topic_id)
    
    # Remove message
    api.remove_message(topic_id, post_id)



### Notification

    # api is a Typetalk::Api
    
    # Get notification list
    response = api.get_notifications
    # Team invitation
    team_id = response.invites.teams[0].team.id
    invite_team_id = response.invites.teams[0].id
    # Topic invitation
    topic_id = response.invites.topic[0].topic.id
    invite_topic_id = response.invites.topic[0].id
    # Mention
    mention_message_text = response.mentions[0].post.message
    mention_topic_name = response.mentions[0].post.topic.name
    mention_sender = response.mentions[0].post.account.name
    
    # Get notification count
    response = api.get_notifications_status
    unopened = response.access.unopened
    team_pending = response.invite.team.pending
    topic_pending = response.invite.topic.pending
    mention_unread = response.mention.unread
    
    # Read notification
    api.read_notifications
    
    # Accept team invitation
    api.accept_team(team_id, invite_team_id)
    
    # Decline team invitation
    api.decline_team(team_id, invite_team_id)
    
    # Accept topic invitation
    api.accept_topic(topic_id, invite_topic_id)
    
    # Decline topic invitation
    api.decline_topic(topic_id, invite_topic_id)



### Mention

    # api is a Typetalk::Api

    # Get mention list
    response = api.get_mentions
    mention_id = response.mentions[0].id
    message_text = response.mentions[0].post.message
    topic_name = response.mentions[0].post.topic.name
    sender = response.mentions[0].post.account.name
    
    # Get unread mention list
    response = api.get_mentions(unread:true)
    
    # Read mention
    api.read_mention(mention_id)





## Contributing

1. Fork it ( https://github.com/umakoz/typetalk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request





## Copyright

Copyright (c) 2014- [Makoto Umami](mailto:umakoz@gmail.com). See [LICENSE]() for details.
