module Lineworks
  module Bot
    module Event
      module MessageType
        Text = 'text'
        Image = 'image'
        #Video = 'video'
        #Audio = 'audio'
        File = 'file'
        Location = 'location'
        Sticker = 'sticker'
        Unsupport = 'unsupport'
      end

      # Webhook event object which contains the sent message.
      #
      # @see: https://developers.worksmobile.com/jp/docs/bot-callback-message
      class Message < Base
        def type
          MessageType.const_get(@src['content']['type'].capitalize)
        rescue NameError => e
          MessageType::Unsupport
        end

        def message
          @src['content']
        end
      end
    end
  end
end
