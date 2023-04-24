# frozen_string_literal: true

require_relative "hs_code/version"
require_relative "hs_code/api_request"

module Uk
  module HsCode
    API_ENDPOINT = "https://www.trade-tariff.service.gov.uk/api"

    class Error < StandardError; end

    class << self
      def search(query)
        search_references(query)
      end

      def search_hs_codes(query)
        result = search_references(query)
        result.map { |a| OpenStruct.new(code: a.attributes.goods_nomenclature_item_id, title: a.attributes.title) }
      end

      private

      def search_references(query)
        ApiRequest.new("#{API_ENDPOINT}/v2/search_references.json", { query: { letter: query } }).get
      end
    end
  end
end
