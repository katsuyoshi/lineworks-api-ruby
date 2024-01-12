# frozen_string_literal: true

require 'line/bot'
require 'lineworks/bot/event'

# @see: message types https://developers.worksmobile.com/jp/docs/bot-send-content

module Lineworks
  module Bot
    # API Client of Line Works Bot SDK Ruby
    #
    #   @client ||= Lineworks::Bot::Client.new do |config|
    #     config.channel_secret = ENV["LINE_WORKS_BOT_SECRET"]
    #     config.channel_token = ENV["LINE_WORKS_ACCESS_TOKEN"]
    #   end
    class Client < Line::Bot::Client
      def endpoint
        @endpoint ||= DEFAULT_ENDPOINT
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
          payload[:content] = Text.new(messages).to_h
        when Hash
          payload[:content] = messages
        end

        endpoint_path = "/bots/#{bot_id}/channels/#{channel_id}/messages"

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
          payload[:content] = Message::Text.new(messages).to_h
        when Hash
          payload[:content] = messages
        end

        endpoint_path = "/bots/#{bot_id}/users/#{user_id}/messages"

        payload = payload.to_json
        post(endpoint, endpoint_path, payload, credentials.merge(headers))
      end

      def parse_events_from(request_body)
        parse_event_from(request_body)
      end

      # Parse events from request.body
      #
      # @param request_body [String]
      #
      # @return Line::Bot::Event::Class
      def parse_event_from(request_body)
        json = JSON.parse(request_body)
        begin
          klass = Event.const_get(Line::Bot::Util.camelize(json['type']))
          klass.new(json)
        rescue NameError
          Event::Base.new(json)
        end
      end

      # Get an user's profile.
      #
      # @param user_id [String] User Id user_id
      # @return [Net::HTTPResponse]
      def get_profile(user_id)
        channel_token_required

        endpoint_path = "/users/#{user_id}"
        get(endpoint, endpoint_path, credentials)
      end

      # Get an user's profile.
      #
      # @param user_id [String] User Id user_id
      # @return [Net::HTTPResponse]
      def get_profile_content(user_id)
        response = get_profile(user_id)
        case response.code
        when '200'
          JSON.parse(response.body, symbolize_names: true)
        else
          { error: 'error' }
        end
      end


    end
  end
end
