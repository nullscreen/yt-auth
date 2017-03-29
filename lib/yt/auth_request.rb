require 'net/http'
require 'json'
require 'yt/auth_error'

module Yt
  # @private
  # A wrapper around Net::HTTP to send HTTP requests to any web API and
  # return their result or raise an error if the result is unexpected.
  class AuthRequest
    # Initializes an AuthRequest object.
    def initialize(options = {})
      @host = options.fetch :host, 'www.googleapis.com'
      @path = options[:path]
      @params = options.fetch :params, {}
      @method = options.fetch :method, :get
      @headers = options.fetch :headers, {}
      @body = options[:body]
      @request_format = options.fetch :request_format, :json
      @error_message = options.fetch :error_message, ->(body) {"Error: #{body}"}
    end

    # Sends the request and returns the response.
    def run
      if response.is_a? Net::HTTPSuccess
        response.tap do
          parse_response!
        end
      else
        raise Yt::AuthError, error_message
      end
    end

  private

    # @return [URI::HTTPS] the (memoized) URI of the request.
    def uri
      attributes = {host: @host, path: @path, query: URI.encode_www_form(query)}
      @uri ||= URI::HTTPS.build attributes
    end

    # Equivalent to @params.transform_keys{|key| key.to_s.camelize :lower}
    def query
      {}.tap do |camel_case_params|
        @params.each_key do |key|
          camel_case_params[camelize key] = @params[key]
        end
      end
    end

    def camelize(part)
      part.to_s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
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
      if @body
        request.set_form_data @body
      end
    end

    # Adds the request headers to the request in the appropriate format.
    # The User-Agent header is also set to recognize the request, and to
    # tell the server that gzip compression can be used, since Net::HTTP
    # supports it and automatically sets the Accept-Encoding header.
    def set_request_headers!(request)
      if @request_format == :json
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
      @headers.each do |name, value|
        request.add_field name, value
      end
    end

    # Run the request and memoize the response or the server error received.
    def response
      @response ||= Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request http_request
      end
    end

    # Replaces the body of the response with the parsed version of the body,
    # according to the format specified in the AuthRequest.
    def parse_response!
      if response.body
        response.body = JSON response.body
      end
    end

    def error_message
      @error_message.call response.body
    end
  end
end
