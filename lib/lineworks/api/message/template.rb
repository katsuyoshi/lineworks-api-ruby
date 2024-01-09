# frozen_string_literal: true

module Lineworks
  module Api
    module Message
      # @see: https://developers.worksmobile.com/jp/docs/bot-channel-message-send
      class Template
        class << self
          # Get a text message hash value.
          #
          # @param messages [String] Message
          # @return [Hash]
          def text(message)
            {
              type: 'text',
              text: message
            }
          end

          # Get a stamp message hash value.
          #
          # @param package_id [Integer] Package Id
          # @param sticker_id [Integer] Sticker Id
          # @return [Hash]
          def stamp(package_id, sticker_id)
            {
              type: 'sticker',
              packageId: package_id.to_s,
              stickerId: sticker_id.to_s
            }
          end

          # Get an image message hash value with image urls.
          #
          # @param preview_url [String] Preview image url (png)
          # @param original_url [String] Original image url (png)
          # @return [Hash]
          def image(original_url, preview_url = nil)
            {
              type: 'image',
              previewImageUrl: preview_url || original_url,
              originalContentUrl: original_url
            }
          end

          # Get an image message hash value with file id.
          #
          # @param preview_url [Integer] Preview image url (png)
          # @param filed [String] File id
          # @return [Hash]
          def image_with_file(file_id)
            {
              type: 'image',
              fileId: file_id
            }
          end

          # Get a file message hash value with url.
          #
          # @param file_url [String] File url
          # @return [Hash]
          def file(file_url)
            {
              type: 'file',
              originalContentUrl: file_url
            }
          end

          # Get a file message hash value with file id.
          #
          # @param file_url [String] File url
          # @return [Hash]
          def file_with_id(file_id)
            {
              type: 'file',
              fileId: file_id
            }
          end

          # Get a link message hash value.
          #
          # @param content [String] Title text
          # @param link [String] Link text
          # @param url [String] Link url
          # @return [Hash]
          def link(content, link, url)
            {
              type: 'link',
              contentText: content,
              linkText: link,
              link: url
            }
          end

          # Get a button message hash value.
          #
          # @param content [String] Title text
          # @param actions [Hash] Actions
          # @param url [String] Link url
          # @return [Hash]
          def button(title, actions)
            {
              type: 'button_template',
              contentText: title,
              actions: actions
            }
          end

          # Get a List template.
          #
          def list(cover, elements, actions = [[], []])
            ListTemplate.new(cover, elements, actions).to_h
          end

          # Get a cover data for list template.
          #
          # @param args [Hash]
          #   title [String] Title text
          #   sub_title [String] Sub title text
          #   image_url [String] Image url
          #   file_id [String] File id
          # @return [Hash]
          def list_cover(args)
            ListTemplate::Cover.new(args).to_h
          end

          # Get a cover data for list template.
          #
          # @param args [Hash]
          #   title [String] Title text
          #   sub_title [String] Sub title text
          #   content_url [String] Content url
          #   file_id [String] File id
          #   actions [Array] Actions
          # @return [Hash]
          def list_element(args)
            ListTemplate::Element.new(args).to_h
          end

          # Create a carousel hash value.
          # @param image_aspect_ratio [String] :rectangle or :square
          # @param image_size [String] :cover or :contain
          # @param columns [Array] Columns
          def carousel(image_aspect_ratio = 'rectangle', image_size = 'cover', columns = [])
            CarouselTemplate.new(image_aspect_ratio, image_size, columns).to_h
          end

          # Create a column object.
          # @param args [Hash]
          #   original_content_url [String] Original content url
          #   file_id [String] File id
          #   title [String] Title text
          #   text [String] Text
          #   default_action [Hash] Default action
          #   actions [Array] Actions
          def carousel_column(args)
            CarouselTemplate::Column.new(args).to_h
          end

          # Create a flexible object.
          # @param alt_text [String] Alt text
          # @param contents [Hash] Contents
          def flexible(alt_text, contents)
            {
              type: 'flex',
              altText: alt_text,
              contents: contents
            }
          end
        end
      end

      class ListTemplate
        attr_accessor :cover, :elements, :actions

        # Get a cover data for list template.
        #
        # @param cover [Cover] Cover data
        # @param elements [Array] Element data
        # @param actions [Array] Actions
        def initialize(cover, elements = [], actions = [[], []])
          @cover = cover
          @elements = elements
          @actions = actions
        end

        def to_h
          {
            type: 'list_template',
            cover: @cover.to_h,
            elements: @elements.map(&:to_h),
            actions: @actions.map { _1.map(&:to_h) }
          }
        end

        # cover data for list template.
        class Cover
          attr_accessor :title, :sub_title, :image_url, :file_id

          # Get a cover data for list template.
          #
          # @param args [Hash]
          #   title [String] Title text
          #   sub_title [String] Sub title text
          #   image_url [String] Image url
          #   file_id [String] File id
          # @return [Hash]
          def initialize(args)
            @title = args[:title]
            @sub_title = args[:sub_title]
            @image_url = args[:image_url]
            @file_id = args[:file_id]
          end

          # Get self as a hash value.
          def to_h
            {
              title: @title,
              subTitle: @sub_title,
              backgroundImageUrl: @image_url,
              backgroundFileId: @file_id
            }.compact
          end
        end

        # Element for list template.
        class Element
          attr_accessor :title, :sub_title, :content_url, :file_id, :actions

          # Get a cover data for list template.
          #
          # @param args [Hash]
          #   title [String] Title text
          #   sub_title [String] Sub title text
          #   content_url [String] Content url
          #   file_id [String] File id
          #   actions [Array] Actions
          # @return [Hash]
          def initialize(args)
            @title = args[:title]
            @sub_title = args[:sub_title]
            @content_url = args[:content_url]
            @file_id = args[:file_id]
            @actions = args[:actions]
          end

          # Get self as a hash value.
          def to_h
            {
              title: @title,
              subTitle: @sub_title,
              contentUrl: @content_url,
              contentFileId: @file_id,
              actions: @actions
            }.compact
          end
        end
      end

      # Get carousel template object.
      class CarouselTemplate
        attr_accessor :image_aspect_ratio, :image_size, :columns

        # Create a carousel template object.
        # @param image_aspect_ratio [String] :rectangle or :square
        # @param image_size [String] :cover or :contain
        # @param columns [Array] Columns
        def initialize(image_aspect_ratio = 'rectangle', image_size = 'cover', columns = [])
          @image_aspect_ratio = image_aspect_ratio
          @image_size = image_size
          @columns = columns
        end

        def to_h
          {
            type: 'carousel',
            imageAspectRatio: @image_aspect_ratio,
            imageSize: @image_size,
            columns: @columns.map(&:to_h)
          }
        end

        # Get a carousel column object.
        class Column
          attr_accessor :original_content_url, :file_id, :title, :text, :default_action, :actions

          # Create a column object.
          # @param args [Hash]
          #   original_content_url [String] Original content url
          #   file_id [String] File id
          #   title [String] Title text
          #   text [String] Text
          #   default_action [Hash] Default action
          #   actions [Array] Actions
          def initialize(args)
            @original_content_url = args[:original_content_url]
            @file_id = args[:file_id]
            @title = args[:title]
            @text = args[:text]
            @defaultAction = args[:default_action]
            @actions = args[:actions]
          end

          # @return [Hash]
          def to_h
            {
              thumbnailImageUrl: @original_content_url,
              imageBackgroundColor: @file_id,
              title: @title,
              text: @text,
              defaultAction: @default_action,
              actions: @actions
            }.compact
          end
        end
      end

      # Get quick reply object.
      class QuickReplyTemplate
        attr_accessor :text, :items
        def initialize text, items
          @text = text
          @items = items || []
        end

        def to_h
          {
            text: @text,
            items: @items.map(&:to_h)
          }.compact
        end

        # Get quick reply item object.
        class QuickReplyItem
          attr_accessor :image_url, :action
          def initialize image_url, action
            @image_url = image_url
            @action = action
          end

          def to_h
            {
              imageUrl: @image_url,
              action: @action.to_h
            }.compact
          end
        end

      end

    end
  end
end
