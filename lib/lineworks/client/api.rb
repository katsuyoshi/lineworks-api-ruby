# frozen_string_literal: true

require 'lineworks/client/version'
require_relative 'api'

module Lineworks

  DEFAULT_OAUTH_ENDPOINT = "https://auth.worksmobile.com"
  DEFAULT_ENDPOINT = 'https://www.worksapis.com/v1.0'

  DEFAULT_HEADERS = {
    'Content-Type' => 'application/json; charset=UTF-8',
    'User-Agent' => "LINEWORKS-API/#{VERSION}"
  }.freeze

end
