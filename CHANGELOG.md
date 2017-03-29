# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

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
