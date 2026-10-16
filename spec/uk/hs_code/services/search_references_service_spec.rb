# frozen_string_literal: true

require "spec_helper"

RSpec.describe Uk::HsCode::Services::SearchReferencesService, type: :service do
  subject(:service) { described_class.new(params) }

  let(:params) { { query: "table" } }

  describe "#call" do
    context "when query is missing or empty" do
      let(:params) { { query: "" } }

      it "raises an ArgumentError" do
        expect { service.call }.to raise_error(ArgumentError, "Missing required query")
      end
    end

    context "when searching references by letter" do
      let(:references_body) do
        {
          data: [
            {
              id: "6133",
              type: "search_reference",
              attributes: {
                title: "table, billiard and bagatelle",
                goods_nomenclature_item_id: "9504000000",
                productline_suffix: "80",
                goods_nomenclature_sid: 54_540
              }
            }
          ]
        }.to_json
      end

      it "returns search reference records via the unified client" do
        stub_request(:get, "https://www.trade-tariff.service.gov.uk/api/v2/search_references.json?query%5Bletter%5D=table")
          .to_return(status: 200, body: references_body, headers: { "Content-Type" => "application/json" })

        records = service.call

        expect(records).to be_an(Array)
        expect(records.size).to eq(1)
        expect(records.first.code).to eq("9504000000")
        expect(records.first.title).to eq("table, billiard and bagatelle")
        expect(records.first.attributes.goods_nomenclature_sid).to eq(54_540)
      end
    end
  end
end
