# frozen_string_literal: true

require "spec_helper"

RSpec.describe Uk::HsCode::Configuration do
  subject(:config) { described_class.new }

  describe "#service" do
    it "defaults to :uk" do
      expect(config.service).to eq(:uk)
      expect(config.base_url).to eq("https://www.trade-tariff.service.gov.uk/api/v2")
    end

    it "switches to Northern Ireland :xi service" do
      config.service = :xi

      expect(config.service).to eq(:xi)
      expect(config.base_url).to eq("https://www.trade-tariff.service.gov.uk/xi/api/v2")
    end

    it "raises an ArgumentError for unsupported services" do
      expect { config.service = :fr }.to raise_error(ArgumentError, /Unsupported service: fr/)
    end
  end

  describe "#base_url=" do
    it "allows overriding the base_url directly" do
      config.base_url = "https://custom-tariff.test/api/v2"

      expect(config.base_url).to eq("https://custom-tariff.test/api/v2")
    end
  end

  describe "#timeout" do
    it "defaults to 10 seconds" do
      expect(config.timeout).to eq(10)
    end

    it "allows setting a custom timeout" do
      config.timeout = 25

      expect(config.timeout).to eq(25)
    end
  end
end
