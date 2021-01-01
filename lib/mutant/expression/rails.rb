# frozen_string_literal: true

module Mutant
  class Expression
    class Rails < self
      include Anima.new(:syntax)

      MAP = IceNine.deep_freeze(
        'rails:controllers' => 'ApplicationController',
        'rails:models'      => 'ApplicationRecord'
      )

      def matcher
        Matcher::Rails.new(const_name: MAP.fetch(syntax))
      end

      def self.try_parse(syntax)
        return unless self::MAP.key?(syntax)

        new(syntax: syntax)
      end
    end # Rails
  end # Expression
end # Mutant
