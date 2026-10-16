# frozen_string_literal: true

module Uk
  module HsCode
    module Entities
      class ExactMatch
        attr_reader :code, :endpoint, :description

        def initialize(code:, endpoint: "commodities", description: nil)
          @code = code
          @endpoint = endpoint
          @description = description || "Exact match for #{code}"
        end

        def title
          @description
        end

        def goods_nomenclature_item_id
          @code
        end

        def declarable
          true
        end

        def score
          nil
        end

        def type
          "exact"
        end

        def to_h
          {
            code: @code,
            endpoint: @endpoint,
            title: title,
            description: @description,
            type: type
          }
        end

        def ==(other)
          other.is_a?(ExactMatch) && code == other.code && endpoint == other.endpoint
        end
      end
    end
  end
end
