[![Build Status](https://travis-ci.org/hugocore/play_store_info.svg)](https://travis-ci.org/hugocore/play_store_info)

# PlayStoreInfo

Get details about any app in the Google Play Store. This gem uses `MetaInspector` to scrape the
app's Play Store web page and retrieve the necessary data.

Compatible with ruby >= 2.3.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'play_store_info'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install play_store_info

## Usage

You first have to read the app details, using the store URL or directly with the ID:

```ruby
app = PlayStoreInfo.read_url('https://play.google.com/store/apps/details?id=com.airbnb.android&hl=en')
app = PlayStoreInfo.read('com.airbnb.android')
```

Then you have some attributes that can be read easily:

```ruby
app.id                  # => "com.airbnb.android"
app.name                # => "Airbnb"
app.artwork            # => "http://lh6.ggpht.com/4jnm0-_9TBUdvNtQpefYE0T33..."
app.description         # => "Make travel planning as mobile as you are..."
```

## Development

After checking out the repo, run `sh bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to debug your code.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hugocore/play_store_info.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
