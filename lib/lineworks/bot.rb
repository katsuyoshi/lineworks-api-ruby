# frozen_string_literal: true

require_relative 'bot/api'
require_relative 'bot/client'
require_relative 'bot/client_authentication'
require_relative 'bot/version'
require_relative 'bot/message'
require_relative 'bot/event'

module Lineworks
  module Bot
    class Error < StandardError; end
  end
end
