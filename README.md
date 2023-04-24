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
# Get all HS codes matching 'table' reference

> refs = Uk::HsCode.search('table')

> refs.inspect

 # => [#<Uk::HsCode::Record id="6133", type="search_reference", attributes=#<Uk::HsCode::Record title="table, billiard and bagatelle", referenced_id="9504", referenced_class="Heading", goods_nomenclature_item_id="9504000000", productline_suffix="80", goods_nomenclature_sid=54540>>,
 #<Uk::HsCode::Record id="11204", type="search_reference", attributes=#<Uk::HsCode::Record title="table cloths, knitted or crocheted", referenced_id="6302", referenced_class="Heading", goods_nomenclature_item_id="6302000000", productline_suffix="80", goods_nomenclature_sid=43645>>,
 #<Uk::HsCode::Record id="11205", type="search_reference", attributes=#<Uk::HsCode::Record title="tablecloths, knitted or crocheted", referenced_id="6302", referenced_class="Heading", goods_nomenclature_item_id="6302000000", productline_suffix="80", goods_nomenclature_sid=43645>>,
 #<Uk::HsCode::Record id="7289", type="search_reference", attributes=#<Uk::HsCode::Record title="tablecloths, of paper", referenced_id="4818300000-80", referenced_class="Commodity", goods_nomenclature_item_id="4818300000", productline_suffix="80", goods_nomenclature_sid=40686>>,
 #<Uk::HsCode::Record id="11206", type="search_reference", attributes=#<Uk::HsCode::Record title="table cloths, other than knitted or crocheted", referenced_id="6302510000-10", referenced_class="Subheading", goods_nomenclature_item_id="6302510000", productline_suffix="10", goods_nomenclature_sid=43679>>

# Get only HS codes with their titles matching 'carpet' reference

> refs = Uk::HsCode.search_hs_codes('carpet')

> refs.inspect

 # => [#<Uk::HsCode::Record code="8451808000", title="carpet cleaning machines liquid injection">,
 #<Uk::HsCode::Record code="4008000000", title="carpet underlay, rubber">,
 #<Uk::HsCode::Record code="5402000000", title="carpet yarn, of man-made filaments">]

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. To test with static code analyzer, run `rake rubocop`. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enigmatt-pl/uk-hs_code.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
