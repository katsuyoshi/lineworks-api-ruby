module Lineworks
  module Bot
    module Message

      # Text message class
      class Text
        attr_accessor :message

        def initialize args
          @message = args[:message]
        end
        
        def to_h
          {
            type: 'text',
            text: message
          }
        end

      end

      # Stamp message class
      class Stamp
        attr_accessor :package_id, :sticker_id

        def initialize args
          @package_id = args[:package_id]
          @sticker_id = args[:sticker_id]
        end
        
        def to_h
          {
            type: 'sticker',
            packageId: package_id.to_s,
            stickerId: sticker_id.to_s
          }
        end

      end

      # Image message class
      class Image
        attr_accessor :original_url, :preview_url, :file_id

        def initialize args
          @original_url = args[:original_url]
          @preview_url = args[:preview_url]
          @file_id = args[:file_id]
        end
        
        def to_h
          # TODO: make a error class
          raise 'preview_url and original_url should be nil.' if file_id unless preview_url.nil? && original_url.nil?
          raise 'file_id should be nil.' if preview_url || original_url unless file_id.nil?

          {
            type: 'image',
            previewImageUrl: preview_url || original_url,
            originalContentUrl: original_url,
            fileId: file_id
          }.compact
        end

      end

      # File message class
      class File
        attr_accessor :url, :file_id

        def initialize args
          @url = args[:url]
          @file_id = args[:file_id]
        end
        
        def to_h
          # TODO: make a error class
          raise 'url should be nil.' if file_id unless url.nil?
          raise 'file_id should be nil.' if url unless file_id.nil?

          {
            type: 'file',
            originalContentUrl: url,
            fileId: file_id
          }.compact
        end

      end

      # Link message class
      class Link
        attr_accessor :content, :link, :url

        def initialize args
          @content = args[:content]
          @link = args[:link]
          @url = args[:url]
        end
        
        def to_h
          {
            type: 'link',
            contentText: content,
            linkText: link,
            link: url
          }
        end

      end

      # Button message class
      class Button
        attr_accessor :title, :actions

        def initialize args
          @title = args[:title]
          @actions = args[:actions]
        end
        
        def to_h
          {
            type: 'button_template',
            contentText: title,
            actions: actions
          }
        end

      end

      # List message class
      class List
        attr_accessor :cover, :elements, :actions

        def initialize args
          @cover = args[:cover]
          @elements = args[:elements]
          @actions = args[:actions] || [[], []]
        end
        
        def to_h
          {
            type: 'list_template',
            cover: cover.to_h,
            elements: elements.map(&:to_h),
            actions: actions.map { _1.map(&:to_h) }
          }.compact
        end

        # cover data for list template.
        class Cover
          attr_accessor :title, :sub_title, :image_url, :file_id

          def initialize(args)
            @title = args[:title]
            @sub_title = args[:sub_title]
            @image_url = args[:image_url]
            @file_id = args[:file_id]
          end

          def to_h
            {
              title: @title,
              subTitle: @sub_title,
              backgroundImageUrl: @image_url,
              backgroundFileId: @file_id
            }.compact
          end
        end

        # Element for List.
        class Element
          attr_accessor :title, :sub_title, :content_url, :file_id, :actions

          def initialize(args)
            @title = args[:title]
            @sub_title = args[:sub_title]
            @content_url = args[:content_url]
            @file_id = args[:file_id]
            @actions = args[:actions]
          end

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

      # Carousel message class
      class Carousel
        attr_accessor :image_aspect_ratio, :image_size, :columns

        def initialize args
          @image_aspect_ratio = args[:image_aspect_ratio] || 'rectangle'
          @image_size = args[:image_size] || 'cover'
          @columns = args[:columns] || []
        end
        
        def to_h
          {
            type: 'carousel',
            imageAspectRatio: image_aspect_ratio,
            imageSize: image_size,
            columns: columns.map(&:to_h)
          }
        end

        # Get a carousel column object.
        class Column
          attr_accessor :original_content_url, :file_id, :title, :text, :default_action, :actions

           def initialize(args)
            @original_content_url = args[:original_content_url]
            @file_id = args[:file_id]
            @title = args[:title]
            @text = args[:text]
            @defaultAction = args[:default_action]
            @actions = args[:actions]
          end

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
      class QuickReply
        attr_accessor :text, :items

        def initialize args
          @text = args[:text]
          @items = args[:items] || []
        end

        def to_h
          {
            text: @text,
            items: @items.map(&:to_h)
          }.compact
        end

        # Get quick reply item object.
        class Item
          attr_accessor :image_url, :action
          def initialize args
            @image_url = args[:image_url]
            @action = args[:action]
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