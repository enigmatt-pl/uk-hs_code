# Uk::HsCode

`uk-hs_code` enables communication with the UK Trade Tariff Public API v2 (https://www.trade-tariff.service.gov.uk/api/v2).

## Installation

Add to your Gemfile:

```ruby
gem 'uk-hs_code'
```

And run:

```bash
bundle install
```

## Configuration

Configure the gem during application startup (e.g., `config/initializers/uk_hs_code.rb`):

```ruby
Uk::HsCode.configure do |config|
  # Target UK tariff (:uk, default) or Northern Ireland tariff (:xi)
  config.service = :uk

  # Optional: Network timeouts in seconds (default: 10)
  config.timeout = 15
end
```

## Usage

### Searching by Commodity Description

```ruby
# Free-text commodity search
result = Uk::HsCode.search('cotton t-shirt')

# Result acts as an Enumerable Array of records
result.first.code
# => "6109100010"

result.first.title
# => "T-shirts"

result.first.declarable
# => true

# Structured access to categorized match groups
result.commodities.each do |commodity|
  puts "#{commodity.code}: #{commodity.description} (declarable: #{commodity.declarable})"
end

result.references.each do |reference|
  puts "#{reference.code}: #{reference.title}"
end
```

### Searching by Exact Commodity Code

```ruby
result = Uk::HsCode.search('6109100010')

result.first.code
# => "6109100010"

result.first.type
# => "exact"
```

### Search References (Alphabetical Index Terms)

```ruby
records = Uk::HsCode.search_references('table')

records.first.code
# => "9504000000"

records.first.title
# => "table, billiard and bagatelle"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run tests and RuboCop. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enigmatt-pl/uk-hs_code.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
