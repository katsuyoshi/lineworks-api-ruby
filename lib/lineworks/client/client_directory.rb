# frozen_string_literal: true

require 'line/bot'
require 'lineworks/directory'

include Lineworks::Directory

# This is a authentication part of Client
# Now only supports Service Account Authentication (JWT).
# @see: https://developers.worksmobile.com/jp/docs/auth-jwt

module Lineworks

  class Client

    def users
      endpoint_path = "/users"

      payload = QueryUsers.new.to_h
      h = get(endpoint, endpoint_path, payload, credentials)
      h[:users].map{|u| User.new(u)}
    end



    # Fetch data, get content of specified URL.
    #
    # @param endpoint_base [String]
    # @param endpoint_path [String]
    # @param headers [Hash]
    #
    # @return [Net::HTTPResponse]
    def get(endpoint_base, endpoint_path, queries={}, headers = {})
      uri = URI.parse(endpoint_base + endpoint_path)
      uri.query = URI.encode_www_form(queries)
      headers = Lineworks::Bot::DEFAULT_HEADERS.merge(headers)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      #request["Content-Type"] = "application/json"
      response = https.request(request)
      JSON.parse(response.body, symbolize_names: true)
    end

  end

end
