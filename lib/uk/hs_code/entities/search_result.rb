# frozen_string_literal: true

module Uk
  module HsCode
    module Entities
      class SearchResult < Array
        attr_reader :query, :type, :commodities, :references, :exact_match

        def initialize(records = [], query: nil, type: "null_match", commodities: [], references: [], exact_match: nil)
          @query = query
          @type = type
          @commodities = commodities || []
          @references = references || []
          @exact_match = exact_match
          super(records)
        end
      end
    end
  end
end
