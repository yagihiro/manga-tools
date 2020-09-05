# Manga::Tools

[![Gem Version](https://badge.fury.io/rb/manga-tools.svg)](https://badge.fury.io/rb/manga-tools)
![Ruby](https://github.com/yagihiro/manga-tools/workflows/Ruby/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/e2797c91a0bd6f521905/maintainability)](https://codeclimate.com/github/yagihiro/manga-tools/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e2797c91a0bd6f521905/test_coverage)](https://codeclimate.com/github/yagihiro/manga-tools/test_coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'manga-tools'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install manga-tools

## Usage

* A search command to find out the release date of a manga

```
$ manga-tools search "ONE PIECE"
```

* Follow the specified title

```
$ manga-tools follow "key"
```

* Displays a list of the titles you are following

```
$ manga-tools follow-list
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yagihiro/manga-tools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yagihiro/manga-tools/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Manga::Tools project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yagihiro/manga-tools/blob/master/CODE_OF_CONDUCT.md).
