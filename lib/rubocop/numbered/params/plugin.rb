# frozen_string_literal: true

require "lint_roller"

module Rubocop
  module Numbered
    module Params
      class Plugin < LintRoller::Plugin
        def about
          LintRoller::About.new(
            name: "rubocop-numbered-params",
            version: VERSION,
            homepage: "https://github.com/tk0miya/rubocop-numbered-params",
            description: "A RuboCop plugin to lint numbered parameters"
          )
        end

        def supported?(context)
          context.engine == :rubocop
        end

        def rules(_context)
          LintRoller::Rules.new(
            type: :path,
            config_format: :rubocop,
            value: Pathname.new(__dir__).join("../../../../config/default.yml")
          )
        end
      end
    end
  end
end
