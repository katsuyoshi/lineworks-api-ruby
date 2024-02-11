# frozen_string_literal: true

require 'line/bot'
require 'lineworks/bot/event'
require 'json'
require 'jwt'

# This is a authentication part of Client
# Now only supports Service Account Authentication (JWT).
# @see: https://developers.worksmobile.com/jp/docs/auth-jwt

module Lineworks

  class Client
    attr_accessor :oauth_endpoint, :bot_secret, :service_account, :private_key
    attr_accessor :access_token_content

    # Update access token if expired.
    def update_access_token scope='bot'
      if access_token_expired?
        if refresh_token_expired?
          !!issue_access_token(scope)
        else
          !!issue_access_token_from_refresh_token
        end
      else
        true
      end
    end

    # line-bot-sdk-ruby uses access_token as channel_token.
    def channel_token
      c = access_token_content
      c ? c[:access_token] : super
    end
    
    private

    def oauth_endpoint
      @oauth_endpoint ||= DEFAULT_OAUTH_ENDPOINT
    end

    # It holds response body of access token.
    def access_token_content= content
      content[:issued_at] = Time.now - 60
      content[:expires_in] = content[:expires_in].to_i

      @access_token_content = content
    end

    # Query access token was expired or not.
    def access_token_expired?
      c = access_token_content
      return true unless c
      return true unless c[:issued_at] && c[:expires_in]
      c[:issued_at] + c[:expires_in]  < Time.now
    end

    # Query refresh token was expired or not.
    def refresh_token_expired?
      c = access_token_content
      return true unless c
      return true unless c[:issued_at]
      c[:issued_at] + (90 * 24 * 60 * 60)  < Time.now
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
      response = https.request(request)
      c = JSON.parse(response.body, symbolize_names: true)
      self.access_token_content = c
      channel_token
    end

    def issue_access_token_from_refresh_token
      c = access_token_content
      return nil unless c
      refresh_token = c[:refresh_token]
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
      response = https.request(request)
      c = JSON.parse(response.body, symbolize_names: true)
      self.access_token_content = c
      channel_token
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
