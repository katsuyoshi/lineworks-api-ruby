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
      attr_accessor :oauth_endpoint, :bot_secret, :service_account, :private_key
      attr_accessor :access_token_content

      def update_access_token scope='bot'
        if access_token_expired?
          if refresh_token_expired?
            !!issue_access_token scope
          else
            !!issue_access_token_from_refresh_token
          end
        else
          true
        end
      end
      
      private

      def access_token_expired?
        c = access_token_content
        return true unless c
        return true unless c[:issued_at] && c[:expires_in]
        c[:issued_at] + c[:expires_in]  < Time.now
      end

      def refresh_token_expired?
        c = access_token_content
        return true unless c
        return true unless c[:issued_at]
        c[:issued_at] + (90 * 24 * 60 * 60)  < Time.now
      end

      def oauth_endpoint
        @oauth_endpoint ||= DEFAULT_OAUTH_ENDPOINT
      end

      # https://qiita.com/caovanbi/items/8abe98a5641c487e4727
      def issue_access_token(scope='bot')
        endpoint_path = '/oauth2/v2.0/token'
        uri = URI.parse(oauth_endpoint + endpoint_path)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/x-www-form-urlencoded"
        request.set_form_data(
          assertion: jwt,
          grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
          client_id: channel_id,
          client_secret: channel_secret,
          scope: scope
        )
p request.body
        response = https.request(request)
p response.body
        @access_token_content = JSON.parse(response.body, symbolize_names: true)
        @access_token_content[:issued_at] = Time.now - 60
        access_token_content[:access_token]
      end

      def issue_access_token_from_refresh_token
        refresh_token = refresh_token_content&[:refresh_token]
        return nil unless refresh_token

        endpoint_path = '/oauth2/v2.0/token'
        uri = URI.parse(oauth_endpoint + endpoint_path)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/x-www-form-urlencoded"
        request.set_form_data(
          refresh_token: refresh_token,
          grant_type: "refresh_token",
          client_id: channel_id,
          client_secret: channel_secret
        )
p request.body
        response = https.request(request)
p response.body
        @access_token_content = JSON.parse(response.body, symbolize_names: true)
        @access_token_content[:issued_at] = Time.now - 60
        access_token_content[:access_token]
      end

      def revoke_access_token
      end

      def jwt
        header = { alg: "RS256", typ: "JWT" }
        payload = {
          iss: channel_id,
          sub: service_account,
          iat: Time.now.to_i,
          exp: Time.now.to_i + 3600
        }
        rsa_private = OpenSSL::PKey::RSA.new(private_key)
        JWT.encode(payload, rsa_private, "RS256", header)
      end
  
     end

  end
end
