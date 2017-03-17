require 'net/http' # for Net::HTTP.start
require 'json' # for JSON.parse
require 'yt/error'

module Yt
  # @private
  # A wrapper around Net::HTTP to send HTTP requests to any web API and
  # return their result or raise an error if the result is unexpected.
  class Request
    # Initializes a Request object.
    def initialize(options = {})
      @host = options.fetch :host, 'www.googleapis.com'
      @path = options[:path]
      @method = options.fetch :method, :get
      @headers = options.fetch :headers, {}
      @body = options[:body]
      @request_format = options.fetch :request_format, :json
    end

    # Sends the request and returns the response.
    def run
      if response.is_a? Net::HTTPSuccess
        response.tap{parse_response!}
      else
        raise Yt::Error, JSON(response.body).to_json
      end
    end

  private


    # @return [URI::HTTPS] the (memoized) URI of the request.
    def uri
      attributes = {host: @host, path: @path}
      @uri ||= URI::HTTPS.build attributes
    end

    # @return [Net::HTTPRequest] the full HTTP request object,
    #   inclusive of headers of request body.
    def http_request
      net_http_class = Object.const_get "Net::HTTP::#{@method.capitalize}"
      @http_request ||= net_http_class.new(uri.request_uri).tap do |request|
        set_request_body! request
        set_request_headers! request
      end
    end

    # Adds the request body to the request in the appropriate format.
    # if the request body is a JSON Object, transform its keys into camel-case,
    # since this is the common format for JSON APIs.
    def set_request_body!(request)
      request.set_form_data @body if @body
    end

    # Adds the request headers to the request in the appropriate format.
    # The User-Agent header is also set to recognize the request, and to
    # tell the server that gzip compression can be used, since Net::HTTP
    # supports it and automatically sets the Accept-Encoding header.
    def set_request_headers!(request)
      if @request_format == :json
        request.initialize_http_header 'Content-Type' => 'application/json'
        request.initialize_http_header 'Content-length' => '0'
      end
      @headers.each{|name, value| request.add_field name, value}
    end

    # Run the request and memoize the response or the server error received.
    def response
      @response ||= Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request http_request
      end
    end

    # Replaces the body of the response with the parsed version of the body,
    # according to the format specified in the Request.
    def parse_response!
      response.body = JSON response.body if response.body
    end
  end
end
