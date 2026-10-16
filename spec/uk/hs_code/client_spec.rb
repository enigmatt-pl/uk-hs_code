# frozen_string_literal: true

require "spec_helper"

RSpec.describe Uk::HsCode::Client do
  subject(:client) { described_class.new(configuration: configuration) }

  let(:configuration) { Uk::HsCode::Configuration.new }

  describe "#get" do
    it "sends GET request with default headers" do
      stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/sections")
        .with(headers: { "User-Agent" => "UK HS Code gem/#{Uk::HsCode::VERSION}", "Accept" => "application/json" })
        .to_return(status: 200, body: { data: [] }.to_json, headers: { "Content-Type" => "application/json" })

      response = client.get("/sections")

      expect(response).to eq({ "data" => [] })
    end

    it "targets the Northern Ireland XI endpoint when configured" do
      configuration.service = :xi

      stub_request(:get, "https://www.trade-tariff.service.gov.uk/xi/api/v2/search?q=milk")
        .to_return(status: 200, body: { data: [] }.to_json, headers: { "Content-Type" => "application/json" })

      response = client.get("/search", { q: "milk" })

      expect(response).to eq({ "data" => [] })
    end

    it "raises Uk::HsCode::Error when status is non-2xx" do
      stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/missing")
        .to_return(status: 404, body: "Not Found", headers: {})

      expect { client.get("/missing") }.to raise_error(Uk::HsCode::Error, /Request failed with status: 404/)
    end
  end
end
