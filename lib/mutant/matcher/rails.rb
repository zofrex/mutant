# frozen_string_literal: true

module Mutant
  class Matcher
    # Abstract base class for method matchers
    class Rails < self
      include Anima.new(:const_name)

      def call(env)
        const = env.world.try_const_get(const_name) or return EMPTY_ARRAY

        Chain.new(
          matched_scopes(env, const).map { |scope| Scope.new(scope.raw) }
        ).call(env)
      end

    private

      def matched_scopes(env, const)
        p const
        env.matchable_scopes.select do |scope|
          const > scope.raw
        end
      end
    end # Method
  end # Matcher
end # Mutant
