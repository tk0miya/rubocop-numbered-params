# frozen_string_literal: true

require "rubocop"

require_relative "params/version"
require_relative "params/plugin"
require_relative "../cop/style/prefer_numbered_parameter"

module Rubocop
  module Numbered
    module Params
      class Error < StandardError; end
    end
  end
end
