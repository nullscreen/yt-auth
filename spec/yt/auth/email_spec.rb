require 'spec_helper'

describe 'Yt::Auth#email' do
  subject(:auth) { Yt::Auth.new attrs }

  context 'given a redirect URI and an authorization code' do
    let(:attrs) { {code: code, redirect_uri: 'http://localhost/'} }

    context 'that is valid' do
      let(:code) { 'valid-code' }

      it 'returns the Google email' do
        http = double('http')
        allow(Net::HTTP).to receive(:start).with('accounts.google.com', 443, use_ssl: true).and_yield http

        request = double('request')
        allow(Net::HTTP::Post).to receive(:new).with(an_instance_of(URI::HTTPS)).and_return request
        allow(request).to receive(:set_form_data).with(attrs.merge({client_id: ENV['YT_CLIENT_ID'],
          client_secret: ENV['YT_CLIENT_SECRET'], grant_type: :authorization_code}))
        response = double('response')
        allow(http).to receive(:request).with(request).and_return(response)
        allow(response).to receive(:body).and_return("{\n" +
          "  \"access_token\" : \"ya29.my-token\",\n" +
          "  \"token_type\" : \"Bearer\"\n" +
          "}")

        http2 = double('http2')
        allow(Net::HTTP).to receive(:start).with('www.googleapis.com', 443, use_ssl: true).and_yield http2

        request2 = double('request2')
        allow(Net::HTTP::Get).to receive(:new).with(an_instance_of(URI::HTTPS)).and_return request2
        allow(request2).to receive(:initialize_http_header).with('Authorization' => "Bearer ya29.my-token")
        response2 = double('response')
        allow(http2).to receive(:request).with(request2).and_return response2
        allow(response2).to receive(:body).and_return '{"email": "user@example.com"}'

        expect(auth.email).to eq 'user@example.com'
      end
    end
  end
end
