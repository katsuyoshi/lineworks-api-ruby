# frozen_string_literal: true

require 'line/bot'
require 'lineworks/bot/event'

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
      #attr_accessor :channel_token, :channel_id, :channel_secret, :endpoint, :blob_endpoint
      attr_accessor :oauth_endpoint, :bot_secret, :service_account, :private_key


      def endpoint
        @endpoint ||= DEFAULT_ENDPOINT
      end

      def oauth_endpoint
        @oauth_endpoint ||= DEFAULT_OAUTH_ENDPOINT
      end

      def issue_access_token(scope='bot')
        channel_id_required
        channel_secret_required

        endpoint_path = '/oauth/accessToken'
        payload = URI.encode_www_form(
          assertion: jwt,
          grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          client_id: channel_id,
          client_secret: channel_secret,
          scope: scope
        )
        headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
        post(endpoint, endpoint_path, payload, headers)
      end

      def jwt
        private_key_required
        channel_id_required
        service_account_required

        if @jwt_expire_at.nil? || Time.now > @jwt_expire_at
          @jwt = nil
        end
        @jwt ||= begin
          private_key = OpenSSL::PKey::RSA.new private_key
          header = {"alg" => "RS256", "typ" => "JWT"}
          @jwt_expire_at = (Time.now + 60 * 60)
          claim = {
              "iss" => channel_id,
              "sub" => service_account,
              "iat" => Time.now.to_i,
              "exp" => @jwt_expire_at.to_i
          }
          jwt = JSON::JWT.new(claim)
          
          jwt.header = header
          jwt.sign(private_key).to_s
        end
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
