# frozen_string_literal: true

require_relative "hs_code/version"
require_relative "hs_code/api_request"

module Uk
  module HsCode
    API_ENDPOINT = "https://www.trade-tariff.service.gov.uk/api"

    class Error < StandardError; end

    def self.search(query)
      query = { query: { letter: query } }

      ApiRequest.new("#{API_ENDPOINT}/v2/search_references.json", query).get
    end
  end
end
