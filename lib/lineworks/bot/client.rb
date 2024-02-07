# frozen_string_literal: true

require 'line/bot'
require 'lineworks/bot/event'
require 'json'
require 'jwt'


# @see: message types https://developers.worksmobile.com/jp/docs/bot-send-content

module Lineworks
  module Bot
    # API Client of Line Works Bot SDK Ruby
    #
    #   @client ||= Lineworks::Bot::Client.new do |config|
    #     config.channel_secret = ENV["LINEWORKS_BOT_SECRET"]
    #     config.channel_token = ENV["LINEWORKS_ACCESS_TOKEN"]
    #   end
    class Client < Line::Bot::Client
      attr_accessor :bot_secret


      def endpoint
        @endpoint ||= DEFAULT_ENDPOINT
      end

     # Override Line::Bot::Client#validate_signature
      # LINE Bot Api uses channel secret for encoding.
      # But LINE WORKS Bot Api uses bot secret for encoding.
      def validate_signature(content, channel_signature, secret = bot_secret)
        return false if !channel_signature || !channel_secret

        hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('SHA256'), secret, content)
        signature = Base64.strict_encode64(hash)

        variable_secure_compare(channel_signature, signature)
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
          payload[:content] = Message::Text.new(messages).to_h
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

      def private_key_required
        raise ArgumentError, '`private_key` is not configured' unless private_key
      end
      
      def service_account_required
        raise ArgumentError, '`service_account` is not configured' unless service_account
      end

      def bot_secret_required
        raise ArgumentError, '`bot_secret` is not configured' unless bot_secret
      end


    end
  end
end
