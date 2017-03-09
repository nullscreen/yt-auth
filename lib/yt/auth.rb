require "yt/auth/version"

# a Ruby client for YouTube.
# @see https://github.com/Fullscreen/yt
module Yt
  # Provides methods to access Google APIs.
  # @see https://developers.google.com/accounts/docs/OAuth2
  class Auth
    def initialize(options = {})
      @redirect_uri = options[:redirect_uri]
    end

    # @return [String]
    # generate the authentication url
    def url
      host = 'accounts.google.com'
      path = '/o/oauth2/auth'
      query = URI.encode_www_form url_params
      URI::HTTPS.build(host: host, path: path, query: query).to_s
    end

  private

    def url_params
      {}.tap do |params|
        params[:client_id] = ENV['YT_CLIENT_ID']
        params[:scope] = 'email'
        params[:redirect_uri] = @redirect_uri
        params[:response_type] = :code
      end
    end
  end
end
