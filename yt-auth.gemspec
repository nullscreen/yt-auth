# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'yt-auth'
  spec.version       = Yt::Auth::VERSION
  spec.authors       = ['Claudio Baccigalupo', 'Kang-Kyu Lee']
  spec.email         = ['claudio@fullscreen.net', 'kang-kyu.lee@fullscreen.net']

  spec.summary       = %q{Google Authentication Ruby client}
  spec.description   = %q{Yt::Auth makes it easy to authenticate users to any
    web application by means of their Google account.}
  spec.homepage      = 'https://github.com/fullscreen/yt-auth'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'yt-support', '>= 0.1.1'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.15'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'yard', '~> 0.9.5'
end
