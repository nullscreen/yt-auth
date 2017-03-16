# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "yt-auth"
  spec.version       = Yt::Auth::VERSION
  spec.authors       = ["Kang-Kyu Lee"]
  spec.email         = ["kang-kyu.lee@fullscreen.com"]

  spec.summary       = %q{a Google OAuth client}
  spec.description   = %q{yt-auth provides a very simple API to log-in with a Google account}
  spec.homepage      = 'https://github.com/fullscreen/yt-auth'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.15'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'yard', '~> 0.9.5'
end
