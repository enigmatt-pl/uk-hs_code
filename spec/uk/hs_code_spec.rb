# frozen_string_literal: true

require "spec_helper"

RSpec.describe Uk::HsCode do
  let(:search_response_body) do
    {
      data: {
        id: "1",
        type: "fuzzy_search",
        attributes: {
          type: "fuzzy_match",
          goods_nomenclature_match: {
            commodities: [
              {
                _score: 9.5,
                _source: {
                  goods_nomenclature_item_id: "9504000000",
                  description: "table, billiard and bagatelle",
                  declarable: true
                }
              },
              {
                _score: 8.2,
                _source: {
                  goods_nomenclature_item_id: "4419000000",
                  description: "tableware, wood",
                  declarable: true
                }
              }
            ]
          },
          reference_match: {
            commodities: []
          }
        }
      }
    }.to_json
  end

  it "has a version number" do
    expect(Uk::HsCode::VERSION).to eq("0.2.0")
  end

  describe "#search" do
    context "when searching tables" do
      before do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search?q=table")
          .to_return(status: 200, body: search_response_body, headers: { "Content-Type" => "application/json" })
      end

      it "returns an array of search results" do
        response = described_class.search("table")

        expect(response).to be_an(Array)
        expect(response.size).to eq(2)
        expect(response.first.code).to eq("9504000000")
        expect(response.first.title).to eq("table, billiard and bagatelle")
      end
    end
  end

  describe "#search_hs_codes" do
    context "when searching tables" do
      before do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search?q=table")
          .to_return(status: 200, body: search_response_body, headers: { "Content-Type" => "application/json" })
      end

      it "returns an array of records with code and title" do
        response = described_class.search_hs_codes("table")

        expect(response.first.code).to eq("9504000000")
        expect(response.first.title).to eq("table, billiard and bagatelle")

        expect(response.last.code).to eq("4419000000")
        expect(response.last.title).to eq("tableware, wood")
      end
    end
  end

  describe "#search_references" do
    let(:references_body) do
      {
        data: [
          {
            id: "6133",
            type: "search_reference",
            attributes: {
              title: "table, billiard and bagatelle",
              goods_nomenclature_item_id: "9504000000"
            }
          }
        ]
      }.to_json
    end

    before do
      stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search_references.json?query%5Bletter%5D=table")
        .to_return(status: 200, body: references_body, headers: { "Content-Type" => "application/json" })
    end

    it "returns search references for backward compatibility" do
      response = described_class.search_references("table")

      expect(response).to be_an(Array)
      expect(response.first.attributes.goods_nomenclature_item_id).to eq("9504000000")
    end
  end
end
