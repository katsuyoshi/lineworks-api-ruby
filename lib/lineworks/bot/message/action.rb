# frozen_string_literal: true

module Lineworks
  module Bot
    module Message
      # @see: https://developers.worksmobile.com/jp/docs/bot-actionobject#postback

      class Action
        class << self
          # Get a postback action hash value.
          #
          # @param label [String] Item label
          # @param data [String] property data
          # @param text [String] display text
          # @return [Hash]
          def postback(label, data, text = nil)
            {
              type: 'postback',
              label: label,
              data: data,
              displayText: text
            }.compact
          end

          # Get a message action hash value.
          #
          # @param label [String] Item label
          # @param text [String] return value
          # @param postback [String] property data
          # @return [Hash]
          def message(label, text, postback = nil)
            {
              type: 'message',
              label: label,
              text: text,
              postback: postback
            }.compact
          end

          # Get a uri action hash value.
          #
          # @param label [String] Item label
          # @param uri [String] uri to open
          # @return [Hash]
          def uri(label, uri)
            {
              type: 'uri',
              label: label,
              uri: uri
            }.compact
          end

          # Get a camera action hash value.
          #
          # @param label [String] Item label
          # @return [Hash]
          def camera(label)
            {
              type: 'camera',
              label: label
            }.compact
          end

          # Get a camera roll action hash value.
          #
          # @param label [String] Item label
          # @return [Hash]
          def camera_roll(label)
            {
              type: 'cameraRoll',
              label: label
            }.compact
          end

          # Get a location action hash value.
          #
          # @param label [String] Item label
          # @return [Hash]
          def location(label)
            {
              type: 'location',
              label: label
            }.compact
          end

          # Get a copy action hash value.
          #
          # @param label [String] Item label
          # @param copy [String] Copy text
          # @return [Hash]
          def copy(label, copy)
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
