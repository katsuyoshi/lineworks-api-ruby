# frozen_string_literal: true

require 'sinatra'       # gem 'sinatra'
require 'lineworks' # gem 'lineworks'
require 'dotenv'        # gem 'dotenv'

Dotenv.load

def client
  @client ||= Lineworks::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_WORKS_BOT_SECRET']
    config.channel_token = ENV['LINE_WORKS_ACCESS_TOKEN']
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
