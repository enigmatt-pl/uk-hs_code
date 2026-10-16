# frozen_string_literal: true

module Uk
  module HsCode
    class Record
      attr_reader :score, :declarable, :type

      def initialize(code: nil, title: nil, description: nil, score: nil, declarable: nil, type: nil, **extra)
        @extra = extra || {}
        @code = code || @extra[:goods_nomenclature_item_id] || @extra["goods_nomenclature_item_id"]
        @title = title || description || @extra[:negated_title] || @extra["negated_title"]
        @description = description || title
        @score = score
        @declarable = declarable
        @type = type
      end

      def code
        @code || self["code"] || self["goods_nomenclature_item_id"]
      end

      def title
        @title || self["title"] || self["description"]
      end

      def description
        @description || self["description"] || self["title"]
      end

      def goods_nomenclature_item_id
        code
      end

      def attributes
        self["attributes"] || self
      end

      def [](key)
        instance_variable_get("@#{key}") || @extra[key.to_s] || @extra[key.to_sym]
      end

      def []=(key, val)
        instance_variable_set("@#{key}", val)
        @extra[key.to_s] = val
        @extra[key.to_sym] = val
      end

      def method_missing(method_name, *args, &block)
        str_key = method_name.to_s
        if str_key.end_with?("=")
          self[str_key.chop] = args.first
        elsif @extra.key?(str_key) || @extra.key?(method_name)
          self[method_name]
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        str_key = method_name.to_s.chomp("=")
        @extra.key?(str_key) || @extra.key?(str_key.to_sym) || super
      end

      def to_h
        {
          code: code,
          title: title,
          description: description,
          score: score,
          declarable: declarable,
          type: type
        }
      end

      def ==(other)
        other.is_a?(Record) && code == other.code && title == other.title
      end
    end
  end
end
