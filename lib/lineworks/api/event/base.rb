module Lineworks
  module Api
    module Event
      class Base
        def initialize(src)
          @src = src
        end

        def [](key)
          @src[key]
        end

        def channel_id
          @src['source']['channelId']
        end

        def domain_id
          @src['source']['domainId']
        end

        def issued_at
          Time.iso8601(@src['issuedTime'])
        end

        def to_hash
          @src
        end
      end
    end
  end
end
