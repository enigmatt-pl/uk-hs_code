# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Domain Entities" do
  describe Uk::HsCode::Entities::Commodity do
    subject(:commodity) do
      described_class.new(
        code: "6109100010",
        description: "T-shirts",
        score: 11.67,
        declarable: true,
        producline_suffix: "80",
        ancestor_descriptions: ["Apparel", "Of cotton"]
      )
    end

    it "exposes commodity attributes and aliases" do
      expect(commodity.code).to eq("6109100010")
      expect(commodity.description).to eq("T-shirts")
      expect(commodity.title).to eq("T-shirts")
      expect(commodity.goods_nomenclature_item_id).to eq("6109100010")
      expect(commodity.score).to eq(11.67)
      expect(commodity.declarable).to be(true)
      expect(commodity.type).to eq("commodity")
      expect(commodity.ancestor_descriptions).to eq(["Apparel", "Of cotton"])
    end

    it "supports equality comparison" do
      same = described_class.new(code: "6109100010", description: "T-shirts")
      different = described_class.new(code: "6109100090", description: "Other")

      expect(commodity).to eq(same)
      expect(commodity).not_to eq(different)
    end
  end

  describe Uk::HsCode::Entities::SearchReference do
    subject(:reference) do
      described_class.new(
        title: "cotton t-shirts, knitted or crocheted",
        code: "6109100010",
        reference_class: "Commodity",
        description: "T-shirts"
      )
    end

    it "exposes reference attributes" do
      expect(reference.title).to eq("cotton t-shirts, knitted or crocheted")
      expect(reference.code).to eq("6109100010")
      expect(reference.reference_class).to eq("Commodity")
      expect(reference.description).to eq("T-shirts")
      expect(reference.type).to eq("reference")
    end
  end

  describe Uk::HsCode::Entities::ExactMatch do
    subject(:exact_match) { described_class.new(code: "6109100010", endpoint: "commodities") }

    it "exposes exact match attributes" do
      expect(exact_match.code).to eq("6109100010")
      expect(exact_match.endpoint).to eq("commodities")
      expect(exact_match.title).to eq("Exact match for 6109100010")
      expect(exact_match.declarable).to be(true)
      expect(exact_match.type).to eq("exact")
    end
  end

  describe Uk::HsCode::Entities::SearchResult do
    subject(:search_result) do
      described_class.new(
        [commodity, reference],
        query: "cotton t-shirt",
        type: "fuzzy_match",
        commodities: [commodity],
        references: [reference]
      )
    end

    let(:commodity) { Uk::HsCode::Entities::Commodity.new(code: "6109100010", description: "T-shirts") }
    let(:reference) { Uk::HsCode::Entities::SearchReference.new(title: "cotton t-shirts", code: "6109100090") }

    it "behaves as an Enumerable Array of records" do
      expect(search_result).to be_an(Array)
      expect(search_result.size).to eq(2)
      expect(search_result.first.code).to eq("6109100010")
      expect(search_result.map(&:code)).to eq(%w[6109100010 6109100090])
    end

    it "provides direct access to categorized sub-collections" do
      expect(search_result.query).to eq("cotton t-shirt")
      expect(search_result.type).to eq("fuzzy_match")
      expect(search_result.commodities.size).to eq(1)
      expect(search_result.references.size).to eq(1)
    end
  end
end
