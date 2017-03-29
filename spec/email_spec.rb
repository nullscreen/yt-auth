require 'spec_helper'

describe 'Yt::Auth#email' do
  context 'not given any authorization code' do
    missing = 'Missing required parameter: code'

    it 'raises an error (missing code)' do
      auth = Yt::Auth.new
      expect{auth.email}.to raise_error Yt::HTTPError, missing
    end
  end

  context 'given an invalid authorization code' do
    invalid = 'Invalid authorization code.'

    it 'raises an error (invalid or already redeemed)' do
      auth = Yt::Auth.new code: rand(36**20).to_s(36)
      expect{auth.email}.to raise_error Yt::HTTPError, invalid
    end
  end

  context 'given a valid authorization code' do
    email = 'user@example.com'
    auth = Yt::Auth.new code: 'valid'

    it 'returns a valid email' do
      expect(auth.email).to eq email
    end

    # NOTE: This test needs to be mocked because getting a real authorization
    # code requires a web interaction from a real user.
    before do
      expect(auth).to receive(:tokens).and_return 'id_token' => '1234'
      expect(JWT).to receive(:decode).and_return [{'email' => email}]
    end
  end
end
