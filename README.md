# Uk::HsCode

uk-hs_code enables to dynamically search Harmonized Codes via UK Trade Tariff API, https://api.trade-tariff.service.gov.uk/#gov-uk-trade-tariff-api.

## Installation

The repository is here: https://github.com/enigmatt-pl/uk-hs_code.git

Add to your Gemfile:

    $ gem 'uk-hs_code'

And:

    $ bundle install


## Usage

```ruby
# Search HS codes matching free-text commodity description
commodities = Uk::HsCode.search('cotton t-shirt')

commodities.first.code
# => "6109100010"

commodities.first.title
# => "T-shirts"

commodities.first.declarable
# => true

# Get only HS codes with their titles
records = Uk::HsCode.search_hs_codes('carpet')

records.first.code
# => "8451808000"

records.first.title
# => "carpet cleaning machines liquid injection"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. To test with static code analyzer, run `rake rubocop`. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enigmatt-pl/uk-hs_code.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
