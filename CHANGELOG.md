# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.3.0  - 2017-08-25

**How to upgrade**

If your code uses `Yt::Auth#url` then you must use `Yt::Auth.url_for` instead.
If your code uses `Yt::Auth.new(code:)` then you must use `Yt::Auth.create(code:)` instead.
If your code uses `Yt::Auth.new(refresh_token:)` then you must use `Yt::Auth.find_by(refresh_token:)` instead.

* [ENHANCEMENT] Extract `Auth#url` into `Auth.url_for`
* [ENHANCEMENT] Rename `Auth.new(code:)` into `Auth.create(code:)`
* [ENHANCEMENT] Rename `Auth.new(refresh_token:)` into `Auth.create(refresh_token:)`
* [FEATURE] Yt::Auth.url_for now accepts the scope to authenticate
* [FEATURE] Yt::Auth.url_for now accepts an option to force re-authentication
* [FEATURE] Add `Auth#revoke` to revoke a refresh token

## 0.2.3  - 2017-08-24

* [FEATURE] Add the ability to generate access token from a refresh token

## 0.2.2  - 2017-05-31

* [FEATURE] Add `Auth#access_token`

## 0.2.1  - 2017-03-29

* [ENHANCEMENT] Speed up process by fetching email with 1 HTTP request (not 2).

## 0.2.0  - 2017-03-29

**How to upgrade**

If your code uses `Yt::AuthError` then you must use `Yt::HTTPError` instead.
If your code uses `Yt::AuthRequest` then you must use `Yt::HTTPRequest` instead.

* [ENHANCEMENT] Extract `AuthError` to `HTTPError` in yt-support gem
* [ENHANCEMENT] Extract `AuthRequest` to `HTTPRequest` in yt-support gem

## 0.1.0  - 2017-03-27

* [FEATURE] Add `AuthError`
* [FEATURE] Add `email`
* [FEATURE] Add `url`
