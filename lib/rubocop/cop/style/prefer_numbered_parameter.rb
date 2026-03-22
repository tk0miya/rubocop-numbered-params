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
        extend AutoCorrector

        MSG = "Use numbered parameters (`_1`, `_2`, ...) instead of named block arguments " \
              "for single-line blocks."

        # @rbs node: RuboCop::AST::BlockNode
        def on_block(node) #: void
          return unless node.single_line?
          return if node.arguments.argument_list.empty?
          return if node.arguments.argument_list.count > max_arguments
          return if node.body.nil?
          return if special_arguments?(node)
          return if contains_inner_block?(node.body)

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @rbs corrector: RuboCop::Cop::Corrector
        # @rbs node: RuboCop::AST::BlockNode
        def autocorrect(corrector, node) #: void # rubocop:disable Metrics/AbcSize
          lvar_nodes = collect_lvar_nodes(node.body)

          argument_list = node.arguments.argument_list #: Array[RuboCop::AST::ArgNode]
          argument_list.each.with_index(1) do |arg, index|
            numbered = "_#{index}"
            lvar_nodes.select { _1.children.first == arg.name }.each do |lvar|
              corrector.replace(lvar.source_range, numbered)
            end
          end

          args_range = node.arguments.source_range
          corrector.remove(args_range.resize(args_range.size + 1))
        end

        # @rbs node: RuboCop::AST::Node?
        def collect_lvar_nodes(node) #: Array[RuboCop::AST::Node]
          return [] unless node

          result = [] #: Array[RuboCop::AST::Node]
          result << node if node.lvar_type?
          node.each_descendant(:lvar) { result << _1 }
          result
        end

        def max_arguments #: Integer
          cop_config.fetch("MaxArguments", 1)
        end

        # @rbs node: RuboCop::AST::BlockNode
        def special_arguments?(node) #: bool
          node.arguments.argument_list.any? do |arg|
            arg.mlhs_type? || arg.restarg_type? || arg.blockarg_type? || arg.shadowarg_type?
          end
        end

        # @rbs node: RuboCop::AST::Node?
        def contains_inner_block?(node) #: bool
          return false unless node

          node.block_type? || node.numblock_type? || node.each_descendant(:block, :numblock).any?
        end
      end
    end
  end
end
