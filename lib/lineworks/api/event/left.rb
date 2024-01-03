module Lineworks
  module Api
    module Event
      # Event object for when your LINE WORKS official account is blocked.
      #
      # No replyToken is generated for this event.
      #
      # @see: https://developers.worksmobile.com/jp/docs/bot-callback-left
      class Left < Joined
      end
    end
  end
end
