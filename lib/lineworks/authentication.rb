require 'json'
require 'time'
require 'json/jwt'
require 'base64'
require "net/http"
require 'singleton'
require 'nokogiri'
require 'openssl'

module Lineworks

  class Authentication
    include Singleton

    DEFAULT_OAUTH_ENDPOINT = "https://auth.worksmobile.com"
    
    def endpoint
      @oauth_endpoint ||= DEFAULT_OAUTH_ENDPOINT
    end


    def issue_access_token
      uri = URI("https://auth.worksmobile.com/oauth2/v2.0/token")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.set_form_data(
        'assertion' => jwt,
        'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'client_id' => ENV['LINEWORKS_CLIENT_ID'],
        'client_secret' => ENV['LINEWORKS_CLIENT_SECRET'],
        'scope' => 'bot'
      )
      response = https.request(request)
p request
p response.body
      JSON.parse(response.body)["access_token"]

=begin
      endpoint_path = '/oauth2/v2.0/token'
      uri = URI.parse(endpoint + endpoint_path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === "https"
      
      params = {
        'assertion' => jwt,
        'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'client_id' => ENV['LINEWORKS_CLIENT_ID'],
        'client_secret' => ENV['LINEWORKS_CLIENT_SECRET'],
        'scope' => 'bot'
      }
      response = Net::HTTP.post_form(uri, params)
puts "params: #{params}"
puts "response: #{response.body}"
      json = JSON.parse(response.body)
      @access_token_expired_at = Time.now + json[""].to_f
      json["access_token"]
=end
    end
  
=begin
    # Issue channel access token
    #
    # @param grant_type [String] Grant type
    #
    # @return [Net::HTTPResponse]
    def issue_channel_token(grant_type = 'client_credentials')
      channel_id_required
      channel_secret_required

      endpoint_path = '/oauth/accessToken'
      payload = URI.encode_www_form(
        grant_type:    grant_type,
        client_id:     channel_id,
        client_secret: channel_secret
      )
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      post(endpoint, endpoint_path, payload, headers)
    end
=end

    def jwt
      if @jwt_expire_at.nil? || Time.now > @jwt_expire_at
        @jwt = nil
      end
      @jwt ||= begin
        private_key = OpenSSL::PKey::RSA.new ENV['LINEWORKS_PRIVATE_KEY']
        header = {"alg" => "RS256", "typ" => "JWT"}
        @jwt_expire_at = (Time.now + 60 * 60)
        claim = {
            "iss" => ENV['LINEWORKS_CLIENT_ID'],
            "sub" => ENV['LINEWORKS_SERVICE_ACCOUNT'],
            "iat" => Time.now.to_i,
            "exp" => @jwt_expire_at.to_i
        }
        jwt = JSON::JWT.new(claim)
        
        jwt.header = header
        jwt.sign(private_key).to_s
      end
    end


  end

end

if $0 == __FILE__
  require('dotenv')#.config({path:'.env'})
  Dotenv.load
  puts Lineworks::Authentication.instance.issue_access_token
end
