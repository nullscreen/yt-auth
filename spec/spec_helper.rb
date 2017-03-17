require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.run_all_when_everything_filtered = false
end

ENV['YT_CLIENT_ID'] =  ENV['YT_ACCOUNT_CLIENT_ID']
ENV['YT_CLIENT_SECRET'] = ENV['YT_ACCOUNT_CLIENT_SECRET']

require 'yt/auth'
