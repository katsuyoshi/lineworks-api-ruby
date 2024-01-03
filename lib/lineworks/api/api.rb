# frozen_string_literal: true

require 'lineworks/api/version'

module Lineworks
  module Api
    # DEFAULT_OAUTH_ENDPOINT = "https://api.line.me"
    DEFAULT_ENDPOINT = 'https://www.worksapis.com/v1.0'
    # DEFAULT_BLOB_ENDPOINT = "https://api-data.line.me/v2"
    # DEFAULT_LIFF_ENDPOINT = "https://api.line.me/liff/v1"

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json; charset=UTF-8',
      'User-Agent' => "LINEWORKS-API/#{VERSION}"
    }.freeze
  end
end
