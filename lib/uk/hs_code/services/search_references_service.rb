# frozen_string_literal: true

module Uk
  module HsCode
    module Services
      class SearchReferencesService
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
          raw_response = @client.get("/search_references.json", { "query[letter]" => query })
          data = raw_response["data"] || []
          data.map do |item|
            attrs = item["attributes"] || {}
            Record.new(
              code: attrs["goods_nomenclature_item_id"],
              title: attrs["title"],
              id: item["id"],
              goods_nomenclature_sid: attrs["goods_nomenclature_sid"],
              productline_suffix: attrs["productline_suffix"]
            )
          end
        end

        def query
          (@params[:query] || @params["query"] || @params[:letter] || @params["letter"]).to_s.strip
        end
      end
    end
  end
end
