# Doctordata

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'doctordata'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install doctordata

## Usage

Create csv text like below:

```rb
csv_str = <<EOS
keyA,#commentB,keyC[0],keyC[1]
a1,b1,c11,c12
a2,b2,c21,c22
EOS
```

Then, parse this to a hash.

```rb
Doctordata::Parser.from_csv_str(csv_str)
# => [{"keyA"=>"a1", "keyC"=>["c11", "c12"]}, {"keyA"=>"a2", "keyC"=>["c21", "c22"]}]
```

You can write keys in the header as www form. If the key starts with `#`, it will be ignored.

You also parse an xlsx file:

```rb
Doctordata::Parser.from_excel(excel_file_or_path)
# => { "Sheet1" => [{"keyA"=>"a1", "keyC"=>["c11", "c12"]}, {"keyA"=>"a2", "keyC"=>["c21", "c22"]}] }
```

The result is a Hash. Top level key is sheet name, and value is array as same as csv example.

It skips if the sheet name starts with `#`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qsona/doctordata.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
