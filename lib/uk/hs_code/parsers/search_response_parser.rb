# frozen_string_literal: true

module Uk
  module HsCode
    module Parsers
      class SearchResponseParser
        def self.call(response_hash)
          new(response_hash).call
        end

        def initialize(response_hash)
          @response_hash = response_hash || {}
        end

        def call
          data = @response_hash["data"] || @response_hash[:data]
          return [] unless data

          type = data["type"] || data[:type]
          attributes = data["attributes"] || data[:attributes] || {}

          case type
          when "exact_search"
            parse_exact_search(attributes)
          when "fuzzy_search"
            parse_fuzzy_search(attributes)
          else
            []
          end
        end

        private

        def parse_exact_search(attributes)
          entry = attributes["entry"] || attributes[:entry] || {}
          code = entry["id"] || entry[:id]
          return [] unless code

          [
            Record.new(
              code: code,
              title: "Exact match for #{code}",
              declarable: true,
              type: "exact"
            )
          ]
        end

        def parse_fuzzy_search(attributes)
          records = []
          seen_codes = {}

          extract_commodities(attributes, records, seen_codes)
          extract_references(attributes, records, seen_codes)

          records
        end

        def extract_commodities(attributes, records, seen_codes)
          gn_commodities = attributes.dig("goods_nomenclature_match", "commodities") || []
          gn_commodities.each do |hit|
            source = hit["_source"] || {}
            code = source["goods_nomenclature_item_id"]
            next if code.nil? || seen_codes[code]

            seen_codes[code] = true
            records << Record.new(
              code: code,
              title: source["description"],
              description: source["description"],
              score: hit["_score"],
              declarable: source["declarable"],
              type: "commodity"
            )
          end
        end

        def extract_references(attributes, records, seen_codes)
          ref_commodities = attributes.dig("reference_match", "commodities") || []
          ref_commodities.each do |hit|
            source = hit["_source"] || {}
            ref_data = source["reference"] || {}
            code = ref_data["goods_nomenclature_item_id"]
            next if code.nil? || seen_codes[code]

            seen_codes[code] = true
            records << Record.new(
              code: code,
              title: source["title"],
              description: ref_data["description"] || source["title"],
              score: hit["_score"],
              declarable: ref_data["declarable"],
              type: "reference"
            )
          end
        end
      end
    end
  end
end
