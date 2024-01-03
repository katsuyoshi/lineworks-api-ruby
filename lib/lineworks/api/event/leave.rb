module Lineworks
  module Api
    module Event
      # Event object for when a user removes your LINE WORKS official account from a group or when your LINE WORKS official account leaves a group or room.
      #
      # No replyToken is generated for this event.
      #
      # https://developers.line.biz/en/reference/messaging-api/#leave-event
      class Leave < Base
      end
    end
  end
end
