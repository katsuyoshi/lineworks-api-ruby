module Lineworks
  module Api
    module Event
      # Event object for when a user performs a postback action which initiates a postback.
      #
      # @see: https://developers.worksmobile.com/jp/docs/bot-callback-postback
      class Postback < Base
        def data
          @src['data']
        end
      end
    end
  end
end
