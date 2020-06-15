# YarnLockParser

This gem is used for parsing yarn.lock files. It is ported from [yarn repository](https://github.com/yarnpkg/yarn/blob/master/src/lockfile/parse.js)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yarn_lock_parser'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install yarn_lock_parser

## Usage

```ruby
 res = YarnLockParser::Parser.parse('spec/fixtures/long_yarn.lock')

[{:name=>"accepts", :version=>"1.3.7"}, {:name=>"array-flatten", :version=>"1.1.1"},
 {:name=>"body-parser", :version=>"1.19.0"}, {:name=>"bytes", :version=>"3.1.0"},
 {:name=>"content-disposition", :version=>"0.5.3"}, {:name=>"content-type", :version=>"1.0.4"},
 {:name=>"cookie-signature", :version=>"1.0.6"}, {:name=>"cookie", :version=>"0.4.0"}, {:name=>"debug", :version=>"2.6.9"}, {:name=>"depd", :version=>"1.1.2"}, {:name=>"destroy", :version=>"1.0.4"}, {:name=>"ee-first", :version=>"1.1.1"}, {:name=>"encodeurl", :version=>"1.0.2"}, {:name=>"escape-html", :version=>"1.0.3"}, {:name=>"etag", :version=>"1.8.1"}, {:name=>"express", :version=>"4.17.1"}, {:name=>"finalhandler", :version=>"1.1.2"}, {:name=>"forwarded", :version=>"0.1.2"}, {:name=>"fresh", :version=>"0.5.2"}, {:name=>"http-errors", :version=>"1.7.2"}, {:name=>"http-errors", :version=>"1.7.3"}, {:name=>"iconv-lite", :version=>"0.4.24"}, {:name=>"inherits", :version=>"2.0.3"}, {:name=>"inherits", :version=>"2.0.4"}, {:name=>"ipaddr.js", :version=>"1.9.1"}, {:name=>"jquery", :version=>"3.4.0"}, {:name=>"media-typer", :version=>"0.3.0"}, {:name=>"merge-descriptors", :version=>"1.0.1"}, {:name=>"methods", :version=>"1.1.2"}, {:name=>"mime-db", :version=>"1.43.0"}, {:name=>"mime-types", :version=>"2.1.26"}, {:name=>"mime", :version=>"1.6.0"}, {:name=>"ms", :version=>"2.0.0"}, {:name=>"ms", :version=>"2.1.1"}, {:name=>"negotiator", :version=>"0.6.2"}, {:name=>"on-finished", :version=>"2.3.0"}, {:name=>"parseurl", :version=>"1.3.3"}, {:name=>"path-to-regexp", :version=>"0.1.7"}, {:name=>"proxy-addr", :version=>"2.0.6"}, {:name=>"qs", :version=>"6.7.0"}, {:name=>"range-parser", :version=>"1.2.1"}, {:name=>"raw-body", :version=>"2.4.0"}, {:name=>"safe-buffer", :version=>"5.1.2"}, {:name=>"safer-buffer", :version=>"2.1.2"}, {:name=>"send", :version=>"0.17.1"}, {:name=>"serve-static", :version=>"1.14.1"}, {:name=>"setprototypeof", :version=>"1.1.1"}, {:name=>"statuses", :version=>"1.5.0"}, {:name=>"toidentifier", :version=>"1.0.0"},...]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eldemcan/yarn_lock_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/eldemcan/yarn_lock_parser/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YarnLockParser project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yarn_lock_parser/blob/master/CODE_OF_CONDUCT.md).
