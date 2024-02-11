require 'active_support/core_ext/string/inflections'

module Lineworks

  # Base class for lineworks objects.
  class ObjBase
    attr_reader :raw_data

    def initialize(raw_data={})
      @raw_data = raw_data
    end

    def method_missing(method, *args, &block)
      key = method.to_s
      case key
      when /(.*)=/
        k = $1.camelize(:lower).to_sym
        raw_data[k] = args.first
      when /(.*)\?/
        k = "is_#{$1}".camelize(:lower).to_sym
        !!raw_data[k]
      else
        k = key.camelize(:lower).to_sym
        if raw_data.key?(k)
          raw_data[k]
        else
          super
        end
      end
    end

  end

end
