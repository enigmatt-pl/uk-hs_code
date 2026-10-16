# frozen_string_literal: true

module Uk
  module HsCode
    module Entities
      class SearchReference
        attr_reader :title, :code, :reference_class, :description, :score, :declarable

        def initialize(title:, code:, reference_class: "Commodity", description: nil, score: nil, declarable: true)
          @title = title
          @code = code
          @reference_class = reference_class
          @description = description || title
          @score = score
          @declarable = declarable
        end

        def goods_nomenclature_item_id
          @code
        end

        def type
          "reference"
        end

        def to_h
          {
            title: @title,
            code: @code,
            reference_class: @reference_class,
            description: @description,
            score: @score,
            declarable: @declarable,
            type: type
          }
        end

        def ==(other)
          other.is_a?(SearchReference) && code == other.code && title == other.title
        end
      end
    end
  end
end
