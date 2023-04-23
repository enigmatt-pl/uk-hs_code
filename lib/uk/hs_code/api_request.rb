# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Uk
  module HsCode
    class ApiRequest
      attr_reader :url, :query_params

      def initialize(url, query_params = {})
        @url = url
        @query_params = query_params
      end

      def get
        request = Net::HTTP::Get.new(parsed_uri)

        add_headers(request)

        http = Net::HTTP.new(parsed_uri.host, parsed_uri.port)
        http.use_ssl = true if parsed_uri.scheme == "https"

        response = http.request(request)

        raise Uk::HsCode::Error, "Request failed with status: #{response.code} - #{response.message}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)["data"]
      end

      private

      def add_headers
        request["User-Agent"] = "UK HS Code gem/#{Uk::HsCode::VERSION}"
        request["Accept"] = "application/json"
      end

      def parsed_uri
        @parsed_uri ||= URI.parse("#{url}?#{query_string}")
      end

      def query_string
        query_params.map do |key, value|
          "#{key}[#{URI.encode_www_form_component(value.keys.first)}]=#{URI.encode_www_form_component(value.values.first)}"
        end.join("&")
      end
    end
  end
end
