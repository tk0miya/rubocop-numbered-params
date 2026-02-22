# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Style::PreferNumberedParameter, :config do
  let(:cop_config) { { "MaxArguments" => max_arguments } }
  let(:max_arguments) { 1 }

  context "with single-line block" do
    context "with method call" do
      it "registers an offense" do
        expect_offense(<<~RUBY)
          users.map { |user| user.name }
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use numbered parameters (`_1`, `_2`, ...) instead of named block arguments for single-line blocks.
        RUBY
      end
    end

    context "with empty body" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          items.each { |item| }
        RUBY
      end
    end

    context "with destructuring arguments" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          pairs.map { |(key, value)| key.to_s + value.to_s }
        RUBY
      end
    end

    context "with splat argument" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          items.each { |*args| args.first }
        RUBY
      end
    end

    context "with block argument" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          items.each { |&block| block.call }
        RUBY
      end
    end

    context "with shadow variables" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          items.each { |item; temp| temp = item.name }
        RUBY
      end
    end

    context "with nested blocks" do
      it "registers an offense on the inner block" do
        expect_offense(<<~RUBY)
          items.select { |item| item.map { |x| x.name } }
                                ^^^^^^^^^^^^^^^^^^^^^^^ Use numbered parameters (`_1`, `_2`, ...) instead of named block arguments for single-line blocks.
        RUBY
      end

      context "when inner block uses numbered parameters" do
        it "does not register an offense" do
          expect_no_offenses(<<~RUBY)
            items.select { |item| item.map { _1.name } }
          RUBY
        end
      end
    end

    context "when arguments exceed MaxArguments" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          hash.each { |key, value| "\#{key}: \#{value}" }
        RUBY
      end
    end

    context "when MaxArguments is 2" do
      let(:max_arguments) { 2 }

      context "with two arguments" do
        it "registers an offense" do
          expect_offense(<<~RUBY)
            hash.each { |key, value| "\#{key}: \#{value}" }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use numbered parameters (`_1`, `_2`, ...) instead of named block arguments for single-line blocks.
          RUBY
        end
      end

      context "with three arguments" do
        it "does not register an offense" do
          expect_no_offenses(<<~RUBY)
            method_call { |a, b, c| a + b + c }
          RUBY
        end
      end
    end
  end

  context "with multi-line block" do
    context "with do...end" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          users.map do |user|
            user.name
          end
        RUBY
      end
    end

    context "with braces" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY)
          users.map { |user|
            user.name
          }
        RUBY
      end
    end
  end

  context "without arguments" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        3.times { puts 'hello' }
      RUBY
    end
  end

  context "with numbered parameters already" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        users.map { _1.name }
      RUBY
    end
  end
end
