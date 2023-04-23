# frozen_string_literal: true

RSpec.describe Uk::HsCode do
  it "has a version number" do
    expect(Uk::HsCode::VERSION).not_to be nil
  end

  describe "#search" do
    let(:expected_search_result) { JSON.parse(File.read("spec/fixtures/expected_search_result.json"), object_class: OpenStruct) }

    context "when searching tables" do
      before { @response = described_class.search("table") }

      it "returns an array of search results" do
        expect(@response).to be_a(Array)
        expect(@response.size).to eq(expected_search_result.size)
      end

      it "returns an expected array of hashes" do
        expect(@response).to eq(expected_search_result)
      end
    end
  end
end
