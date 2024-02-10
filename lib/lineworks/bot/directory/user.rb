module Lineworks
  module Bot
    module Directory
      
      # Query users in the domain.
      # params: args [Hash]
      #   domain_id [String] optional
      #   count [Integer] optional
      #   cursor [String] optional
      #   filter [Symbol] optional :vip
      #   order [Symbol] optional :name or :time
      #   sort [Symbol] optional  :asc or :desc
      class QueryUsers
        attr_accessor :domain_id, :count, :cursor, :filter, :order, :sort

        def initialize(args={})
          case args
          when Hash
            domain_id = args[:domain_id]
            count = args[:count] || 100
            cursor = args[:cursor]
            filter = args[:filter]
            order = args[:order]
            sort = args[:sort]
          end
        end

        def to_h
          {
            domainId: domain_id,
            count: count,
            cursor: cursor,
            searghFilterType: search_filter_type,
            orderBy: order_by,
            sortOrder: sort_order
          }.compact
        end

        private

        def search_filter_type
          case filter
          when :vip
            'VIP'
          else
            nil
          end
        end

        def order_by
          case order
          when :name
            'NAME'
          when :time
            'CREATED_TIME'
          else
            nil
          end
        end

        def sort_order
          case sort
          when :asc
            'ASCENDING'
          when :desc
            'DESCENDING'
          else
            nil
          end
        end

      end

      class User
      end

    end
  end
end

