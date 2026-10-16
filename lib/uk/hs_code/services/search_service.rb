# frozen_string_literal: true

module Uk
  module HsCode
    module Services
      class SearchService
        def self.call(...)
          new(...).call
        end

        def initialize(params = {}, client: Client.new, **keyword_params)
          merged_params = keyword_params.empty? ? params : keyword_params
          @params = merged_params.is_a?(Hash) ? merged_params : { query: merged_params }
          @client = client
        end

        def call
          validate_prerequisites!
          execute_workflow
        end

        private

        def validate_prerequisites!
          raise ArgumentError, "Missing required query" if query.empty?
        end

        def execute_workflow
          raw_response = @client.get("/search", { q: query })
          Parsers::SearchResponseParser.call(raw_response)
        end

        def query
          (@params[:query] || @params["query"] || @params[:q] || @params["q"]).to_s.strip
        end
      end
    end
  end
end
