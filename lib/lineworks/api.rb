# frozen_string_literal: true

require_relative 'api/api'
require_relative 'api/client'
require_relative 'api/version'
require_relative 'api/message'

module Lineworks
  module Api
    class Error < StandardError; end
  end
end
