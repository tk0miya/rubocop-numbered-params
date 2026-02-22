# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Recommends using numbered parameters (`_1`, `_2`) instead of
      # named block arguments in single-line blocks with few arguments.
      #
      # @example
      #   # bad
      #   users.map { |user| user.name }
      #   items.select { |item| item.active? }
      #
      #   # good
      #   users.map { _1.name }
      #   items.select { _1.active? }
      #
      #   # good - multi-line block (not targeted)
      #   users.map do |user|
      #     user.name
      #   end
      #
      # @example MaxArguments: 2
      #   # bad
      #   hash.each { |key, value| "#{key}: #{value}" }
      #
      #   # good
      #   hash.each { "#{_1}: #{_2}" }
      #
      class PreferNumberedParameter < Base
        MSG = "Use numbered parameters (`_1`, `_2`, ...) instead of named block arguments " \
              "for single-line blocks."

        def on_block(node)
          return unless node.single_line?
          return if node.arguments.empty?
          return if node.arguments.count > max_arguments
          return if node.body.nil?
          return if special_arguments?(node)
          return if contains_inner_block?(node.body)

          add_offense(node)
        end

        private

        def max_arguments
          cop_config.fetch("MaxArguments", 1)
        end

        def special_arguments?(node)
          node.arguments.any? do |arg|
            arg.mlhs_type? || arg.restarg_type? || arg.blockarg_type? || arg.shadowarg_type?
          end
        end

        def contains_inner_block?(node)
          return false unless node

          node.block_type? || node.numblock_type? || node.each_descendant(:block, :numblock).any?
        end
      end
    end
  end
end
