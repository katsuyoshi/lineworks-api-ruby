require_relative '../obj_base'
require_relative 'user_organization'

module Lineworks
  module Directory
    
    # User class
    class User < ObjBase

      def initialize(args={})
        super
        case args
        when Hash
          @raw_data[:userName] = UserName.new(args[:userName]) if args[:userName].is_a?(Hash)
          @raw_data[:organizations] = (args[:organizations] || []).map { |o| o.is_a?(Hash) ? UserOrganization.new(o) : o }
          @raw_data[:messenger] = Messenger.new(args[:messenger]) if args[:messenger].is_a?(Hash)
          @raw_data[:customFields] = (args[:customFields] || []).map { |o| o.is_a?(Hash) ? UserCustomField.new(o) : o }
          @raw_data[:relations] = (args[:relations] || []).map { |o| o.is_a?(Hash) ? UserRelation.new(o) : o }
        end
      end

    end

    class UserName < ObjBase
      def display_name
        "#{last_name} #{first_name}"
      end
    end

    class LeaveOfAbsence < ObjBase
    end

    class Messenger < ObjBase
    end

    class UserCustomField < ObjBase
    end

    class UserRelation < ObjBase
    end










        # Query users in the domain.
    # @params: args [Hash]
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


  end
end

