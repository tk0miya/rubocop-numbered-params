# rubocop-numbered-params

A RuboCop plugin that recommends using numbered parameters (`_1`, `_2`, ...) instead of named block arguments in single-line blocks.

## Installation

Add the gem to your application's Gemfile:

```bash
bundle add rubocop-numbered-params
```

Or install it directly:

```bash
gem install rubocop-numbered-params
```

Then add it to your `.rubocop.yml`:

```yaml
plugins:
  - rubocop-numbered-params
```

## Cops

### Style/PreferNumberedParameter

Recommends using numbered parameters (`_1`, `_2`, ...) instead of named block arguments in single-line blocks. This cop supports autocorrection.

**Bad:**

```ruby
users.map { |user| user.name }
items.select { |item| item.active? }
```

**Good:**

```ruby
users.map { _1.name }
items.select { _1.active? }
```

Multi-line blocks are not targeted:

```ruby
# good - multi-line block (not targeted)
users.map do |user|
  user.name
end
```

#### Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `MaxArguments` | `1` | Maximum number of block arguments to target. Blocks with more arguments than this value are ignored. |

Example with `MaxArguments: 2`:

```yaml
Style/PreferNumberedParameter:
  MaxArguments: 2
```

```ruby
# bad
hash.each { |key, value| "#{key}: #{value}" }

# good
hash.each { "#{_1}: #{_2}" }
```

#### Exceptions

The cop does not register an offense in the following cases:

- Multi-line blocks
- Blocks with an empty body
- Blocks with destructuring arguments: `|(key, value)|`
- Blocks with splat arguments: `|*args|`
- Blocks with block arguments: `|&block|`
- Blocks with shadow variables: `|item; temp|`
- Outer blocks that contain inner blocks (the inner block is checked separately)

## Requirements

- Ruby >= 3.2.0
- RuboCop >= 1.72.1

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tk0miya/rubocop-numbered-params. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tk0miya/rubocop-numbered-params/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the rubocop-numbered-params project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tk0miya/rubocop-numbered-params/blob/main/CODE_OF_CONDUCT.md).
