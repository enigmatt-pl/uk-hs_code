# frozen_string_literal: true

require_relative "hs_code/version"
require_relative "hs_code/configuration"
require_relative "hs_code/entities/commodity"
require_relative "hs_code/entities/search_reference"
require_relative "hs_code/entities/exact_match"
require_relative "hs_code/entities/search_result"
require_relative "hs_code/record"
require_relative "hs_code/client"
require_relative "hs_code/parsers/search_response_parser"
require_relative "hs_code/services/search_service"
require_relative "hs_code/api_request"

module Uk
  module HsCode
    API_ENDPOINT = "https://www.trade-tariff.service.gov.uk/api/v2"

    class Error < StandardError; end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration) if block_given?
      end

      def reset_configuration!
        @configuration = Configuration.new
      end

      def search(query)
        Services::SearchService.call(query: query)
      end

      def search_hs_codes(query)
        search(query)
      end

      def search_references(query)
        ApiRequest.new("#{configuration.base_url}/search_references.json", { query: { letter: query } }).get
      end
    end
  end
end
