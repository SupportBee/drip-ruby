require "drip/resource"

module Drip
  class Error < Resource
    def self.resource_name
      "error"
    end

    def attribute_keys
      %w{code attribute message}.map(&:to_sym)
    end
  end
end
