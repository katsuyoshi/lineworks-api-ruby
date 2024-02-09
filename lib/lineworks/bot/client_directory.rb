# frozen_string_literal: true

require 'line/bot'
require 'lineworks/bot/directory'

include Lineworks::Bot::Directory

# This is a authentication part of Client
# Now only supports Service Account Authentication (JWT).
# @see: https://developers.worksmobile.com/jp/docs/auth-jwt

module Lineworks
  module Bot

    class Client

      def users
        endpoint_path = "/users"

        payload = QueryUsers.new.to_h.to_json
        post(endpoint, endpoint_path, payload, credentials.merge(headers))
      end

    end


  end
end
