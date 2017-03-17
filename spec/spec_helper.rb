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

require 'yt/auth'

Yt.configure do |config|
  config.client_id = ENV['YT_ACCOUNT_CLIENT_ID']
  config.client_secret = ENV['YT_ACCOUNT_CLIENT_SECRET']
end
