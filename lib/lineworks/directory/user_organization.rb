require_relative '../obj_base'

module Lineworks
  module Directory
    
    class UserOrganization < ObjBase
      def initialize(args=[])
        super
        case args
        when Hash
          @raw_data[:orgUnits] = (args[:orgUnits] || []).map { |o| o.is_a?(Hash) ? OrgUnit.new(o) : o }
        end
      end
    end

    class OrgUnit < ObjBase
    end

  end
end