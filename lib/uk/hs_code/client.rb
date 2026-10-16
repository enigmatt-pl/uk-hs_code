# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Uk
  module HsCode
    class Client
      def initialize(configuration: Uk::HsCode.configuration, base_url: nil)
        @configuration = configuration
        @base_url = base_url || @configuration.base_url
      end

      def get(path, params = {})
        uri = build_uri(path, params)
        request = Net::HTTP::Get.new(uri)
        apply_headers(request)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"
        http.open_timeout = @configuration.timeout
        http.read_timeout = @configuration.timeout

        response = http.request(request)
        handle_response(response)
      end

      private

      def apply_headers(request)
        request["User-Agent"] = @configuration.user_agent
        request["Accept"] = "application/json"
      end

      def build_uri(path, params)
        full_url = "#{@base_url}#{path}"
        uri = URI.parse(full_url)
        if params && !params.empty?
          query_str = URI.encode_www_form(params)
          uri.query = uri.query ? "#{uri.query}&#{query_str}" : query_str
        end
        uri
      end

      def handle_response(response)
        raise Uk::HsCode::Error, "Request failed with status: #{response.code} - #{response.message}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      end
    end
  end
end
