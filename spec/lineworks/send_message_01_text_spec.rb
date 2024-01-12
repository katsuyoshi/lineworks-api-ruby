require 'spec_helper'
require 'webmock/rspec'
require 'json'

describe Lineworks::Bot::Client do
  it 'send the text message to the channel' do
    uri_template = Addressable::Template.new Lineworks::Bot::DEFAULT_ENDPOINT + '/bots/bot_id/channels/channel_id/messages'
    stub_request(:post, uri_template).to_return { |request| { body: request.body, status: 200 } }

    client = Lineworks::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    bot_id = 'bot_id'
    channel_id = 'channel_id'
    message = 'Hello, world'
    response = client.send_messages_to_channel(bot_id, channel_id, message)
    expected = {
      content: {
        type: 'text',
        text: message
      }
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'send the text message in a hash to the channel' do
    uri_template = Addressable::Template.new Lineworks::Bot::DEFAULT_ENDPOINT + '/bots/bot_id/channels/channel_id/messages'
    stub_request(:post, uri_template).to_return { |request| { body: request.body, status: 200 } }

    client = Lineworks::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    bot_id = 'bot_id'
    channel_id = 'channel_id'
    message = {
      type: 'text',
      text: 'Hello, world'
    }
    response = client.send_messages_to_channel(bot_id, channel_id, message)

    expected = {
      content: message
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'send the text message to the user' do
    uri_template = Addressable::Template.new Lineworks::Bot::DEFAULT_ENDPOINT + '/bots/bot_id/users/user_id/messages'
    stub_request(:post, uri_template).to_return { |request| { body: request.body, status: 200 } }

    client = Lineworks::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    bot_id = 'bot_id'
    user_id = 'user_id'
    message = 'Hello, world'
    response = client.send_messages_to_user(bot_id, user_id, message)

    expected = {
      content: {
        type: 'text',
        text: message
      }
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'send the text message in a hash to the user' do
    uri_template = Addressable::Template.new Lineworks::Bot::DEFAULT_ENDPOINT + '/bots/bot_id/users/user_id/messages'
    stub_request(:post, uri_template).to_return { |request| { body: request.body, status: 200 } }

    client = Lineworks::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    bot_id = 'bot_id'
    user_id = 'user_id'
    message = {
      type: 'text',
      text: 'Hello, world'
    }
    response = client.send_messages_to_user(bot_id, user_id, message)

    expected = {
      content: message
    }.to_json
    expect(response.body).to eq(expected)
  end
end
