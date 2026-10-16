# frozen_string_literal: true

module Uk
  module HsCode
    module Entities
      class Commodity
        attr_reader :code, :description, :score, :declarable, :producline_suffix,
                    :number_indents, :chapter, :heading, :section, :ancestor_descriptions

        def initialize(code:, description:, score: nil, declarable: true, producline_suffix: "80",
                       number_indents: 0, chapter: nil, heading: nil, section: nil, ancestor_descriptions: [])
          @code = code
          @description = description
          @score = score
          @declarable = declarable
          @producline_suffix = producline_suffix
          @number_indents = number_indents
          @chapter = chapter
          @heading = heading
          @section = section
          @ancestor_descriptions = ancestor_descriptions || []
        end

        def title
          @description
        end

        def goods_nomenclature_item_id
          @code
        end

        def type
          "commodity"
        end

        def to_h
          {
            code: @code,
            description: @description,
            title: title,
            score: @score,
            declarable: @declarable,
            producline_suffix: @producline_suffix,
            number_indents: @number_indents,
            chapter: @chapter,
            heading: @heading,
            section: @section,
            ancestor_descriptions: @ancestor_descriptions,
            type: type
          }
        end

        def ==(other)
          other.is_a?(Commodity) && code == other.code && description == other.description
        end
      end
    end
  end
end
