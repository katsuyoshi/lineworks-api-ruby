# LINE WORKS API for Ruby

This gem is to use access to LINE WORKS API from Ruby.  
This uses [LINE Messaging API SDK for Ruby](https://github.com/line/line-bot-sdk-ruby) and builds this on it.  
Thanks for LINE Corp.  

It's just beginning to be made; Uses may change.

## Documentation

Pleas visit official API documentation.  
[LINE WORKS Developers](https://developers.worksmobile.com/jp/docs)  

## Installation


Add this line to your application's Gemfile:

```ruby
gem 'lineworks-api'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install lineworks-api
```

## Examples

There are examples in an examples folder.  

A simple echo back bot is here. See more details below link.  
[Echo bot](examples/echobot/README.md)

Codes are just like below.

```
require 'sinatra'       # gem 'sinatra'
require 'lineworks-api' # gem 'lineworks-api'
require 'dotenv'        # gem 'dotenv'

Dotenv.load

def client
  @client ||= Lineworks::Api::Client.new { |config|
    config.channel_secret = ENV["LINE_WORKS_BOT_SECRET"]
    config.channel_token = ENV["LINE_WORKS_ACCESS_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_WORKS_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  bot_id = request.env['HTTP_X_WORKS_BOTID']
  body = JSON.parse(body)
  channel_id = body['source']['channelId']
  user_id = body['source']['userId']

  case body['type']
  when 'message'
    client.send_messages_to_channel(bot_id, channel_id, body['content']['text'])
  end

  # Don't forget to return a successful response
  "OK"
end
```
