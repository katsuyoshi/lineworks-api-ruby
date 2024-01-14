# LINE WORKS API for Ruby

This gem is to use access to LINE WORKS API from Ruby.  
This uses [LINE Messaging API SDK for Ruby](https://github.com/line/line-bot-sdk-ruby) and builds this on it.  
Thanks for LINE Corp.  

It's just beginning to be made; Uses may change.

## Documentation

Pleas visit official API documentation.  
[LINE WORKS Developers](https://developers.worksmobile.com/jp/docs)  

## Installation


Download this project.  
Move to the project directory.  
Run rake command.  

```
bundle install
rake install:local
```

__Caution:__   
The instruction below is not ready because it’s not registered to RubyGems.  
Refer below after registration.


Add this line to your application's Gemfile:

```ruby
gem 'lineworks'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install lineworks
```

## Examples

There are examples in an examples folder.  

A simple echo back bot is here. See more details below link.  
[Echo bot](examples/echobot/README.md)

Codes are just like below.

```
require 'sinatra'       # gem 'sinatra'
require 'lineworks' # gem 'lineworks'
require 'dotenv'        # gem 'dotenv'

Dotenv.load

def client
  @client ||= Lineworks::Bot::Client.new do |config|
    config.channel_secret = ENV['LINEWORKS_BOT_SECRET']
    config.channel_token = ENV['LINEWORKS_ACCESS_TOKEN']
  end
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_WORKS_SIGNATURE']
  error 400 do 'Bad Request' end unless client.validate_signature(body, signature)

  bot_id = request.env['HTTP_X_WORKS_BOTID']
  event = client.parse_event_from(body)

  case event
  when Lineworks::Bot::Event::Message
    case event.type
    when Lineworks::Bot::Event::MessageType::Text
      client.send_messages_to_channel(bot_id, event.channel_id, event.message['text'])
    end
  end

  # Don't forget to return a successful response
  'OK'
end
```
