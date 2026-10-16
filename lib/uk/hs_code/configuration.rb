# frozen_string_literal: true

module Uk
  module HsCode
    class Configuration
      SERVICE_URLS = {
        uk: "https://www.trade-tariff.service.gov.uk/api/v2",
        xi: "https://www.trade-tariff.service.gov.uk/xi/api/v2"
      }.freeze

      DEFAULT_TIMEOUT = 10

      attr_accessor :timeout, :user_agent
      attr_writer :base_url
      attr_reader :service

      def initialize
        @service = :uk
        @base_url = nil
        @timeout = DEFAULT_TIMEOUT
        @user_agent = "UK HS Code gem/#{Uk::HsCode::VERSION}"
      end

      def service=(val)
        symbolized = val.to_s.downcase.to_sym
        raise ArgumentError, "Unsupported service: #{val}. Use :uk or :xi." unless SERVICE_URLS.key?(symbolized)

        @service = symbolized
      end

      def base_url
        @base_url || SERVICE_URLS.fetch(@service)
      end
    end
  end
end
