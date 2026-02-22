# frozen_string_literal: true

require_relative "lib/rubocop/numbered/params/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-numbered-params"
  spec.version = Rubocop::Numbered::Params::VERSION
  spec.authors = ["Takeshi KOMIYA"]
  spec.email = ["i.tkomiya@gmail.com"]

  spec.summary = "A RuboCop plugin to lint numbered parameters"
  spec.description = "A RuboCop plugin to lint numbered parameters"
  spec.homepage = "https://github.com/tk0miya/rubocop-numbered-params"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tk0miya/rubocop-numbered-params"
  spec.metadata["changelog_uri"] = "https://github.com/tk0miya/rubocop-numbered-params/blob/main/CHANGELOG.md"
  spec.metadata["default_lint_roller_plugin"] = "Rubocop::Numbered::Params::Plugin"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { File.basename(_1) }
  spec.require_paths = ["lib"]

  spec.add_dependency "lint_roller", "~> 1.0"
  spec.add_dependency "rubocop", ">= 1.72.1"
end
