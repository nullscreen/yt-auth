require 'spec_helper'

describe 'Yt::Auth#email' do
  subject(:auth) { Yt::Auth.new attrs }

  context 'not given any authorization code' do
    let(:attrs) { {} }
    message = 'Missing required parameter: code'

    it {expect{auth.email}.to raise_error Yt::Error, message}
  end

  context 'given an invalid authorization code' do
    let(:attrs) { {code: rand(36**20).to_s(36)} }
    message = 'Invalid authorization code.'

    it {expect{auth.email}.to raise_error Yt::Error, message}
  end

  context 'given a duplicate authorization code' do
    let(:attrs) { {code: 'invalid'} }
    message = 'Code was already redeemed.'

    it {expect{auth.email}.to raise_error Yt::Error}
    it {expect{auth.email}.to raise_error Yt::Error, message}
  end

  # NOTE: This test needs to be mocked because getting a real authorization
  # code requires a web interaction from a real user.
  context 'given a valid authorization code' do
    let(:attrs) { {code: 'valid'} }
    let(:tokens) { {'access_token' => 'ya29.example'} }
    let(:email) { 'user@example.com' }

    it 'returns a valid email' do
      expect(auth).to receive(:tokens).and_return tokens

      response = double 'response'
      expect_any_instance_of(Yt::Request).to receive(:run).and_return response
      expect(response).to receive(:body).and_return 'email' => email

      expect(auth.email).to eq email
    end
  end
end
