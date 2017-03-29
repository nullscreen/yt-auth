require 'yt/config'
require 'yt/http_request'

# An object-oriented Ruby client for YouTube.
# @see http://www.rubydoc.info/gems/yt/
module Yt
  # Provides methods to authenticate a user with the Google OAuth flow.
  # @see https://developers.google.com/accounts/docs/OAuth2
  class Auth
    # @param [Hash] options the options to initialize an instance of Yt::Auth.
    # @option options [String] :redirect_uri The URI to redirect users to
    #   after they have completed the Google OAuth flow.
    # @option options [String] :code A single-use authorization code provided
    #   by Google OAuth to obtain an access token to access Google API.
    def initialize(options = {})
      @redirect_uri = options[:redirect_uri]
      @code = options[:code]
    end

    # @return [String] the URL where to authenticate with a Google account.
    def url
      host = 'accounts.google.com'
      path = '/o/oauth2/auth'
      query = URI.encode_www_form url_params
      URI::HTTPS.build(host: host, path: path, query: query).to_s
    end

    # @return [String] the email of an authenticated Google account.
    def email
      response = HTTPRequest.new(email_params).run
      response.body['email']
    end

  private

    def url_params
      {}.tap do |params|
        params[:client_id] = Yt.configuration.client_id
        params[:scope] = :email
        params[:redirect_uri] = @redirect_uri
        params[:response_type] = :code
      end
    end

    def email_params
      {}.tap do |params|
        params[:path] = '/oauth2/v2/userinfo'
        params[:headers] = {Authorization: "Bearer #{tokens['access_token']}"}
      end
    end

    # @return [Hash] the tokens of an authenticated Google account.
    def tokens
      HTTPRequest.new(tokens_params).run.body
    end

    def tokens_params
      {}.tap do |params|
        params[:host] = 'accounts.google.com'
        params[:path] = '/o/oauth2/token'
        params[:method] = :post
        params[:request_format] = :form
        params[:body] = tokens_body
        params[:error_message] = ->(body) {
          JSON(body)['error_description'] || 'Invalid authorization code.'
        }
      end
    end

    def tokens_body
      {}.tap do |params|
        params[:client_id] = Yt.configuration.client_id
        params[:client_secret] = Yt.configuration.client_secret
        params[:code] = @code
        params[:redirect_uri] = @redirect_uri
        params[:grant_type] = :authorization_code
      end
    end
  end
end
