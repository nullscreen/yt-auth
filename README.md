# Yt::Auth

Welcome to yt-auth! Authenticate the users with Google account.

[![Build Status](https://travis-ci.org/Fullscreen/yt-auth.svg?branch=master)](https://travis-ci.org/Fullscreen/yt-auth)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yt-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yt-auth

## Usage

Use `Yt::Auth#url` to generate an authentication URL with a redirect URI:

    auth = Yt::Auth.new redirect_uri: "http://example.com"
    auth.url
    # => "https://accounts.google.com/o/oauth2/auth..."

## Environment Variables

`YT_CLIENT_ID` should be set with your Google client ID, after registering your application at [Google Developers Console](https://console.developers.google.com).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fullscreen/yt-auth.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
