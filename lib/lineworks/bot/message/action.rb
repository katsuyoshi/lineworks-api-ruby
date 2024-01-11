# frozen_string_literal: true

module Lineworks
  module Bot
    module Message
      module Action
        # @see: https://developers.worksmobile.com/jp/docs/bot-actionobject#postback


        # Get a postback action.
        class Postback
          attr_accessor :label, :data, :text

          def initialize label, data=nil, text=nil
            case label
            when Hash
              @label = label[:label]
              @data = label[:data]
              @text = label[:text]
            else
              @label = label
              @data = data
              @text = text
            end
          end

          def to_h
            {
              type: 'postback',
              label: label,
              data: data,
              displayText: text
            }.compact
          end
        end

        # Get a message action hash value.
        class Message
          attr_accessor :label, :text, :data

          def initialize label, text=nil, data=nil
            case label
            when Hash
              @label = label[:label]
              @text = label[:text]
              @data = label[:data]
            else
              @label = label
              @text = text
              @data = data
            end
          end

          def to_h
            {
              type: 'message',
              label: label,
              text: text,
              postback: data
            }.compact
          end
        end

        # Get a uri action hash value.
        class Uri
          attr_accessor :label, :uri

          def initialize label, uri=nil
            case label
            when Hash
              @label = label[:label]
              @uri = label[:uri]
            else
              @label = label
              @uri = uri
            end
          end

          def to_h
            {
              type: 'uri',
              label: label,
              uri: uri
            }.compact
          end
        end

        # Get a camera action hash value.
        class Camera
          attr_accessor :label

          def initialize label
            case label
            when Hash
              @label = label[:label]
            else
              @label = label
            end
          end

          def to_h
            {
              type: 'camera',
              label: label
            }.compact
          end
        end

        # Get a camera roll action hash value.
        class CameraRoll
          attr_accessor :label

          def initialize label
            case label
            when Hash
              @label = label[:label]
            else
              @label = label
            end
          end

          def to_h
            {
              type: 'cameraRoll',
              label: label
            }.compact
          end
        end

        # Get a location action hash value.
        class Location
          attr_accessor :label

          def initialize label
            case label
            when Hash
              @label = label[:label]
            else
              @label = label
            end
          end

          def to_h
            {
              type: 'location',
              label: label
            }.compact
          end
        end

        # Get a copy action hash value.
        class Copy
          attr_accessor :label, :copy

          def initialize label, copy=nil
            case label
            when Hash
              @label = label[:label]
              @copy = label[:copy]
            else
              @label = label
              @copy = copy
            end
          end

          def to_h
            {
              type: 'copy',
              label: label,
              copyText: copy
            }.compact
          end
        end

      end
    end
  end
end
