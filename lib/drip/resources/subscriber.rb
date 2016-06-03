require "drip/resource"
require "time"

module Drip
  class Subscriber < Resource
    def self.resource_name
      "subscriber"
    end

    def attribute_keys
      %w{id status email custom_fields tags time_zone utc_offset visitor_uuid created_at href}.map(&:to_sym)
    end
  end
end
