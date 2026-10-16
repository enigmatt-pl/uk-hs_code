# frozen_string_literal: true

require "spec_helper"

RSpec.describe Uk::HsCode::Services::SearchService, type: :service do
  subject(:service) { described_class.new(params) }

  let(:params) { { query: "cotton t-shirt" } }

  describe "#call" do
    context "when query is missing or empty" do
      let(:params) { { query: "" } }

      it "raises an ArgumentError" do
        expect { service.call }.to raise_error(ArgumentError, "Missing required query")
      end
    end

    context "when searching for a commodity description" do
      let(:response_body) do
        {
          data: {
            id: "1",
            type: "fuzzy_search",
            attributes: {
              type: "fuzzy_match",
              goods_nomenclature_match: {
                commodities: [
                  {
                    _score: 11.67,
                    _source: {
                      goods_nomenclature_item_id: "6109100010",
                      description: "T-shirts",
                      declarable: true
                    }
                  }
                ]
              },
              reference_match: {
                commodities: [
                  {
                    _score: 6.13,
                    _source: {
                      title: "cotton t-shirts, knitted or crocheted",
                      reference: {
                        goods_nomenclature_item_id: "6109100090",
                        description: "Other",
                        declarable: true
                      }
                    }
                  }
                ]
              }
            }
          }
        }.to_json
      end

      it "returns matching commodity records without external network calls" do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search?q=cotton+t-shirt")
          .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })

        records = service.call

        expect(records).to be_an(Array)
        expect(records.size).to eq(2)

        expect(records.first.code).to eq("6109100010")
        expect(records.first.title).to eq("T-shirts")
        expect(records.first.declarable).to be(true)
        expect(records.first.type).to eq("commodity")

        expect(records.last.code).to eq("6109100090")
        expect(records.last.title).to eq("cotton t-shirts, knitted or crocheted")
        expect(records.last.type).to eq("reference")
      end
    end

    context "when searching for an exact commodity code" do
      let(:params) { { query: "6109100010" } }
      let(:response_body) do
        {
          data: {
            id: "6109100010",
            type: "exact_search",
            attributes: {
              type: "exact_match",
              entry: {
                endpoint: "commodities",
                id: "6109100010"
              }
            }
          }
        }.to_json
      end

      it "returns an exact match record" do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search?q=6109100010")
          .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })

        records = service.call

        expect(records.size).to eq(1)
        expect(records.first.code).to eq("6109100010")
        expect(records.first.type).to eq("exact")
      end
    end

    context "when search yields no results" do
      let(:params) { { query: "unknownitem" } }
      let(:response_body) do
        {
          data: {
            id: "1",
            type: "fuzzy_search",
            attributes: {
              type: "fuzzy_match",
              goods_nomenclature_match: { commodities: [] },
              reference_match: { commodities: [] }
            }
          }
        }.to_json
      end

      it "returns an empty array" do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search?q=unknownitem")
          .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })

        expect(service.call).to eq([])
      end
    end

    context "when the upstream API returns an error status" do
      it "raises a Uk::HsCode::Error" do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search?q=cotton+t-shirt")
          .to_return(status: 500, body: "Internal Server Error", headers: {})

        expect { service.call }.to raise_error(Uk::HsCode::Error, /Request failed with status: 500/)
      end
    end
  end
end
