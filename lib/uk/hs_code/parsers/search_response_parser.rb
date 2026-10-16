# frozen_string_literal: true

module Uk
  module HsCode
    module Parsers
      class SearchResponseParser
        def self.call(response_hash, query: nil)
          new(response_hash, query: query).call
        end

        def initialize(response_hash, query: nil)
          @response_hash = response_hash || {}
          @query = query
        end

        def call
          data = @response_hash["data"] || @response_hash[:data]
          return Entities::SearchResult.new([], query: @query) unless data

          type = data["type"] || data[:type]
          attributes = data["attributes"] || data[:attributes] || {}

          case type
          when "exact_search"
            parse_exact_search(attributes)
          when "fuzzy_search"
            parse_fuzzy_search(attributes)
          else
            Entities::SearchResult.new([], query: @query, type: type.to_s)
          end
        end

        private

        def parse_exact_search(attributes)
          entry = attributes["entry"] || attributes[:entry] || {}
          code = entry["id"] || entry[:id]
          endpoint = entry["endpoint"] || entry[:endpoint] || "commodities"
          return Entities::SearchResult.new([], query: @query, type: "exact_match") unless code

          exact = Entities::ExactMatch.new(code: code, endpoint: endpoint)
          Entities::SearchResult.new([exact], query: @query, type: "exact_match", exact_match: exact)
        end

        def parse_fuzzy_search(attributes)
          commodities = extract_commodities(attributes)
          references = extract_references(attributes)
          records = (commodities + references).uniq(&:code)

          Entities::SearchResult.new(
            records,
            query: @query,
            type: "fuzzy_match",
            commodities: commodities,
            references: references
          )
        end

        def extract_commodities(attributes)
          commodities = []
          gn_commodities = attributes.dig("goods_nomenclature_match", "commodities") || []

          gn_commodities.each do |hit|
            source = hit["_source"] || {}
            code = source["goods_nomenclature_item_id"]
            next if code.nil?

            commodities << Entities::Commodity.new(
              code: code,
              description: source["description"],
              score: hit["_score"],
              declarable: source["declarable"],
              producline_suffix: source["producline_suffix"],
              number_indents: source["number_indents"],
              chapter: source["chapter"],
              heading: source["heading"],
              section: source["section"],
              ancestor_descriptions: source["ancestor_descriptions"]
            )
          end

          commodities
        end

        def extract_references(attributes)
          references = []
          ref_commodities = attributes.dig("reference_match", "commodities") || []

          ref_commodities.each do |hit|
            source = hit["_source"] || {}
            ref_data = source["reference"] || {}
            code = ref_data["goods_nomenclature_item_id"]
            next if code.nil?

            references << Entities::SearchReference.new(
              code: code,
              title: source["title"],
              description: ref_data["description"] || source["title"],
              score: hit["_score"],
              declarable: ref_data["declarable"],
              reference_class: source["reference_class"] || "Commodity"
            )
          end

          references
        end
      end
    end
  end
end
