require 'line/bot'

# @see: message types https://developers.worksmobile.com/jp/docs/bot-send-content

module Lineworks
  module Api
    # API Client of Line Works Bot SDK Ruby
    #
    #   @client ||= Lineworks::Bot::Client.new do |config|
    #     config.channel_secret = ENV["LINE_WORKS_BOT_SECRET"]
    #     config.channel_token = ENV["LINE_WORKS_ACCESS_TOKEN"]
    #   end
    class Client < Line::Bot::Client

      def endpoint
        @endpoint ||= API::DEFAULT_ENDPOINT
      end

      # Push messages to a channel using channel_id.
      # @see: https://developers.worksmobile.com/jp/docs/bot-channel-message-send
      #
      # @param bot_id [String] Bot Id
      # @param channel_id [String] Channel Id
      # @param content [Hash] Message Objects
      # @param headers [Hash] HTTP Headers
      # @param payload [Hash] Additional request body
      # @return [Net::HTTPResponse]
      def push_messages_to_channel(bot_id, channel_id, content, headers: {}, payload: {})
        channel_token_required

        payload[:content]
    
        endpoint_path = "/bots/#{bot_id}/channels/#{channel_id}/messages"

        payload = payload.to_json
        post(endpoint, endpoint_path, payload, credentials.merge(headers))
      end

      # Push messages to a user using user_id.
      # @see: https://developers.worksmobile.com/jp/docs/bot-user-message-send
      #
      # @param bot_id [String] Bot Id
      # @param user_id [String] User Id
      # @param content [Hash] Message Objects
      # @param headers [Hash] HTTP Headers
      # @param payload [Hash] Additional request body
      # @return [Net::HTTPResponse]
      def send_messages_to_user(bot_id, user_id, content, headers: {}, payload: {})
        channel_token_required

        payload[:content]
   
        endpoint_path = "/bots/#{bot_id}/users/#{user_id}/messages"

        payload = payload.to_json
        post(endpoint, endpoint_path, payload, credentials.merge(headers))
      end

      # Send messages to a channel using channel_id.
      # @see: https://developers.worksmobile.com/jp/docs/bot-channel-message-send
      #
      # @param bot_id [String] Bot Id
      # @param channel_id [String] Channel Id
      # @param messages [String, Hash] Message Objects
      # @param headers [Hash] HTTP Headers
      # @param payload [Hash] Additional request body
      # @return [Net::HTTPResponse]
      def send_messages_to_channel(bot_id, channel_id, messages, headers: {}, payload: {})
        channel_token_required

        case messages
        when String
          payload[:content] = Message::Template.text messages
        when Hash
          payload[:content] = messages
        end
    
        endpoint_path = "/bots/#{bot_id}/channels/#{channel_id}/messages"

p [endpoint, endpoint_path, payload]
        payload = payload.to_json
        post(endpoint, endpoint_path, payload, credentials.merge(headers))
      end

      # Send messages to a user using user_id.
      # @see: https://developers.worksmobile.com/jp/docs/bot-user-message-send
      #
      # @param bot_id [String] Bot Id
      # @param user_id [String] User Id
      # @param messages [String, Hash] Message Objects
      # @param headers [Hash] HTTP Headers
      # @param payload [Hash] Additional request body
      # @return [Net::HTTPResponse]
      def send_messages_to_user(bot_id, user_id, messages, headers: {}, payload: {})
        channel_token_required

        case messages
        when String
          payload[:content] = Message::Template.text messages
        when Hash
          payload[:content] = messages
        end
    
        endpoint_path = "/bots/#{bot_id}/users/#{user_id}/messages"

        payload = payload.to_json
        post(endpoint, endpoint_path, payload, credentials.merge(headers))
      end

    end
  end
end
