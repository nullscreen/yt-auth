require 'jwt'
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
    def self.create(options = {})
      new options.merge(grant_type: :authorization_code)
    end

    # @param [Hash] options the options to initialize an instance of Yt::Auth.
    # @option options [String] :refresh_token A multi-use refresh token to
    #   obtain an access token to access Google API.
    def self.find_by(options = {})
      new options.merge(grant_type: :refresh_token)
    end

    # @return [String] the URL where to authenticate with a Google account.
    # @param [Hash] options the options to initialize an instance of Yt::Auth.
    # @option options [String] :redirect_uri The URI to redirect users to
    #   after they have completed the Google OAuth flow.
    # @option options [Boolean] :force whether to force users to re-authenticate
    #   an account that was previously authenticated.
    # @option options [Array<String>] :scopes The list of scopes that users
    #   are requested to authorize.
    def self.url_for(options = {})
      host = 'accounts.google.com'
      path = '/o/oauth2/auth'
      query = URI.encode_www_form url_params(options)
      URI::HTTPS.build(host: host, path: path, query: query).to_s
    end

    # @param [Hash] options the options to initialize an instance of Yt::Auth.
    # @option options [String] :grant_type
    # @option options [String] :redirect_uri
    # @option options [String] :code
    # @option options [String] :refresh_token
    def initialize(options = {})
      @tokens_body = options
      @tokens_body[:client_id] = Yt.configuration.client_id
      @tokens_body[:client_secret] = Yt.configuration.client_secret
    end

    # @return [Boolean] whether the authentication was revoked.
    def revoke
      !!HTTPRequest.new(revoke_params).run
    end

    # @return [String] the email of an authenticated Google account.
    def email
      profile['email']
    end

    # @return [String] the access token of an authenticated Google account.
    def access_token
      tokens['access_token']
    end

    # @return [String] the refresh token of an authenticated Google account.
    def refresh_token
      tokens['refresh_token']
    end

  private

    def self.url_params(options)
      {}.tap do |params|
        params[:client_id] = Yt.configuration.client_id
        params[:scope] = scope_for(options.fetch :scopes, [])
        params[:access_type] = :offline
        params[:approval_prompt] = options[:force] ? :force : :auto
        params[:redirect_uri] = options[:redirect_uri]
        params[:response_type] = :code
      end
    end

    def self.scope_for(scopes)
      ['userinfo.email'].concat(scopes).map do |scope|
        "https://www.googleapis.com/auth/#{scope}"
      end.join(' ')
    end

    # @return [Hash] the tokens of an authenticated Google account.
    def tokens
      @tokens ||= HTTPRequest.new(tokens_params).run.body
    end

    # @return [Hash] the profile of an authenticated Google account.
    def profile
      decoded_tokens = JWT.decode tokens['id_token'], nil, false
      decoded_tokens[0]
    end

    def tokens_params
      {}.tap do |params|
        params[:host] = 'accounts.google.com'
        params[:path] = '/o/oauth2/token'
        params[:method] = :post
        params[:request_format] = :form
        params[:body] = @tokens_body
        params[:error_message] = ->(body) { error_message_for body }
      end
    end

    def revoke_params
      {}.tap do |params|
        params[:host] = 'accounts.google.com'
        params[:path] = '/o/oauth2/revoke'
        params[:params] = {token: refresh_token || access_token}
      end
    end

    def error_message_for(body)
      key = @tokens_body[:grant_type].to_s.tr '_', ' '
      JSON(body)['error_description'] || "Invalid #{key}."
    end
  end
end
