require 'json'
require 'net/http'

require "yt/auth/version"

# a Ruby client for YouTube.
# @see https://github.com/Fullscreen/yt
module Yt
  # Provides methods to access Google APIs.
  # @see https://developers.google.com/accounts/docs/OAuth2
  class Auth
    #
    def initialize(options = {})
      @redirect_uri = options[:redirect_uri]
      @code = options[:code]
    end

    # @return [String]
    # generate the authentication url
    def url
      host = 'accounts.google.com'
      path = '/o/oauth2/auth'
      query = URI.encode_www_form url_params
      URI::HTTPS.build(host: host, path: path, query: query).to_s
    end

    # @return [String]
    #
    def email
      token = post_for_token
      get_for_email(token)
    end

  private

    def post_for_token
      host = 'accounts.google.com'
      path = '/o/oauth2/token'
      uri = URI::HTTPS.build host: host, path: path
      http_request = Net::HTTP::Post.new(uri).tap do |request|
        request.set_form_data(authentication_params)
      end
      net_http_options = [uri.host, uri.port, use_ssl: true]
      response = Net::HTTP.start(*net_http_options) do |http|
        http.request http_request
      end
      response_body = JSON.parse(response.body)
      response_body['access_token']
    end

    def get_for_email(access_token)
      host = 'www.googleapis.com'
      path = '/oauth2/v2/userinfo'
      uri = URI::HTTPS.build host: host, path: path
      http_request = Net::HTTP::Get.new(uri).tap do |request|
        request.initialize_http_header 'Authorization' => "Bearer #{access_token}"
      end
      net_http_options = [uri.host, uri.port, use_ssl: true]
      response = Net::HTTP.start(*net_http_options) do |http|
        http.request http_request
      end
      response_body = JSON.parse response.body
      response_body['email']
    end

    def authentication_params
      {}.tap do |params|
        params[:client_id] = ENV['YT_CLIENT_ID']
        params[:client_secret] = ENV['YT_CLIENT_SECRET']
        params[:code] = @code
        params[:redirect_uri] = @redirect_uri
        params[:grant_type] = :authorization_code
      end
    end

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
