Yt::Auth - authenticate users with their Google account
=======================================================

Yt::Auth helps you write apps that need to authenticate users by means of their Google account.

The **source code** is available on [GitHub](https://github.com/fullscreen/yt-auth) and the **documentation** on [RubyDoc](http://www.rubydoc.info/gems/yt-auth/frames).

[![Build Status](http://img.shields.io/travis/Fullscreen/yt-auth/master.svg)](https://travis-ci.org/Fullscreen/yt-auth)
[![Coverage Status](http://img.shields.io/coveralls/Fullscreen/yt-auth/master.svg)](https://coveralls.io/r/Fullscreen/yt-auth)
[![Dependency Status](http://img.shields.io/gemnasium/Fullscreen/yt-auth.svg)](https://gemnasium.com/Fullscreen/yt-auth)
[![Code Climate](http://img.shields.io/codeclimate/github/Fullscreen/yt-auth.svg)](https://codeclimate.com/github/Fullscreen/yt-auth)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://www.rubydoc.info/gems/yt-auth/frames)
[![Gem Version](http://img.shields.io/gem/v/yt-auth.svg)](http://rubygems.org/gems/yt-auth)

The Yt::Auth library provides two methods: `url` and `email`.

Yt::Auth#url
------------

With the `url` method, you can obtain a URL where to redirect users who need to
authenticate with their Google account in order to use your application:

```ruby
redirect_uri = 'https://example.com/auth' # REPLACE WITH REAL ONE
Yt::Auth.new(redirect_uri: redirect_uri).url
 # => https://accounts.google.com/o/oauth2/auth?client_id=...&scope=email&redirect_uri=https%3A%2F%2Fexample.com%2Fauth&response_type=code
```

Yt::Auth#email
--------------

After users have authenticated with their Google account, they will be
redirected to the `redirect_uri` you indicated, with an extra `code` query
parameter, e.g. `https://example.com/auth?code=1234`

With the `email` method, you can obtain the verified email of the users:

```ruby
redirect_uri = 'https://example.com/auth' # REPLACE WITH REAL ONE
code = '1234' # REPLACE WITH REAL ONE
Yt::Auth.new(redirect_uri: redirect_uri, code: code).email
 # => "user@example.com"
```

Yt::AuthError
-------------

`Yt::AuthError` will be raised whenever something goes wrong during the
authentication process. The message of the error will include the details:

```ruby
redirect_uri = 'https://example.com/auth' # REPLACE WITH REAL ONE
code = 'this-is-not-a-valid-code'
Yt::Auth.new(redirect_uri: redirect_uri, code: code).email
 # => Yt::AuthError: Invalid authorization code.
```


How to contribute
=================

Contribute to the code by forking the project, adding the missing code,
writing the appropriate tests and submitting a pull request.

In order for a PR to be approved, all the tests need to pass and all the public
methods need to be documented and listed in the guides. Remember:

- to run all tests locally: `bundle exec rspec`
- to generate the docs locally: `bundle exec yard`
- to list undocumented methods: `bundle exec yard stats --list-undoc`
