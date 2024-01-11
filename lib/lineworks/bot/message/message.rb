module Lineworks
  module Bot
    module Message

      # Text message class
      class Text
        attr_accessor :message

        def initialize message
          case message
          when Hash
            @message = message[:message]
          else
            @message = message
          end
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

        def initialize package_id, sticker_id=nil
          case package_id
          when Hash
            @package_id = package_id[:package_id]
            @sticker_id = package_id[:sticker_id]
          else
            @package_id = package_id
            @sticker_id = sticker_id
          end
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

        def initialize original_url, preview_url=nil, arfile_idg_b=nil
          case original_url
          when Hash
            @original_url = original_url[:original_url]
            @preview_url = original_url[:preview_url]
            @file_id = original_url[:file_id]
          else
            @original_url = original_url
            @preview_url = preview_url
            @file_id = file_id
          end
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

        def initialize url, file_id=nil
          case url
          when Hash
            @url = url[:url]
            @file_id = url[:file_id]
          else
            @url = url
            @file_id = file_id
          end  
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
        attr_accessor :content_text, :link_text, :url

        def initialize content_text, link_text=nil, url=nil
          case content_text
          when Hash
            @content_text = content_text[:content_text]
            @link_text = content_text[:link_text]
            @url = content_text[:url]
          else
            @content_text = content_text
            @link_text = link_text
            @url = url
          end
        end
        
        def to_h
          {
            type: 'link',
            contentText: content_text,
            linkText: link_text,
            link: url
          }
        end

      end

      # Button message class
      class Button
        attr_accessor :title, :actions

        def initialize title, actions=nil
          case title
          when Hash
            @title = title[:title]
            @actions = title[:actions] || []
          else
            @title = title
            @actions = actions || []
          end
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

        def initialize cover, elements=nil, actions=nil
          case cover
          when Hash
            @cover = cover[:cover]
            @elements = cover[:elements] || []
            @actions = cover[:actions] || [[], []]
          else
            @cover = cover
            @elements = elements || []
            @actions = actions || [[], []]
          end
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

          def initialize(title, sub_title=nil, content_url=nil, file_id=nil, actions=nil)
            case title
            when Hash
              @title = title[:title]
              @sub_title = title[:sub_title]
              @content_url = title[:content_url]
              @file_id = title[:file_id]
              @actions = title[:actions]
            else
              @title = title
              @sub_title = sub_title
              @content_url = content_url
              @file_id = file_id
              @actions = actions || []
            end
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

        def initialize image_aspect_ratio, image_size=nil, columns=nil
          case image_aspect_ratio
          when Hash
            @image_aspect_ratio = image_aspect_ratio[:image_aspect_ratio] || 'rectangle'
            @image_size = image_aspect_ratio[:image_size] || 'cover'
            @columns = image_aspect_ratio[:columns] || []
          else
            @image_aspect_ratio = image_aspect_ratio || 'rectangle'
            @image_size = image_size || 'cover'
            @columns = columns || []
            end
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

          def initialize(original_content_url, file_id=nil, title=nil, text=nil, default_action=nil, actions=nil)
            case original_content_url
            when Hash
              @original_content_url = original_content_url[:original_content_url]
              @file_id = original_content_url[:file_id]
              @title = original_content_url[:title]
              @text = original_content_url[:text]
              @default_action = original_content_url[:default_action]
              @actions = original_content_url[:actions] || []
            else
              @original_content_url = original_content_url
              @file_id = file_id
              @title = title
              @text = text
              @default_action = default_action
              @actions = actions || []
            end
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

      # Create a flexible object.
      # @param alt_text [String] Alt text
      # @param contents [Hash] Contents
      class Flex
        attr_accessor :alt_text, :contents
        def initialize alt_text, contents=nil
          case alt_text
          when Hash
            @alt_text = alt_text[:alt_text]
            @contents = alt_text[:contents]
          else
            @alt_text = alt_text
            @contents = contents
          end
        end

        def to_h
          {
            type: 'flex',
            altText: alt_text,
            contents: contents
        }.compact
        end
      end

      # Get quick reply object.
      class QuickReply
        attr_accessor :text, :items

        def initialize text, items=nil
          case text
          when Hash
            @text = text[:text]
            @items = text[:items] || []
          else
            @text = text
            @items = items || []
            end
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
          def initialize image_url, action=nil
            case image_url
            when Hash
              @image_url = image_url[:image_url]
              @action = image_url[:action]
            else
              @image_url = image_url
              @action = action
            end
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