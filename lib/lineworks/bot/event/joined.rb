module Lineworks
  module Bot
    module Event
      # Event object for when your LINE WORKS official account is added as a friend (or unblocked).
      # You can reply to follow events.
      #
      # @see: https://developers.worksmobile.com/jp/docs/bot-callback-joined
      class Joined < Base
        def members
          @src['members']
        end
      end
    end
  end
end
