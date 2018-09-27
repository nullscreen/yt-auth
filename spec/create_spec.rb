require 'spec_helper'

describe 'Yt::Auth.create' do
  context 'not given any authorization code' do
    missing = 'Missing required parameter: code'

    it 'raises an error (missing code)' do
      auth = Yt::Auth.create
      expect{auth.email}.to raise_error Yt::HTTPError, missing
    end
  end

  context 'given an invalid authorization code' do
    invalid = 'Malformed auth code.'

    it 'raises an error (invalid or already redeemed)' do
      auth = Yt::Auth.create code: rand(36**20).to_s(36)
      expect{auth.email}.to raise_error Yt::HTTPError, invalid
    end
  end

  context 'given a valid authorization code' do
    email = 'user@example.com'
    auth = Yt::Auth.create code: 'valid'
    tokens = {'id_token' => '12', 'access_token' => 'a', 'refresh_token' => 'b'}

    it 'returns a valid email' do
      expect(auth.email).to eq email
      expect(auth.access_token).to eq 'a'
      expect(auth.refresh_token).to eq 'b'
    end

    # NOTE: This test needs to be mocked because getting a real authorization
    # code requires a web interaction from a real user.
    before do
      expect(auth).to receive(:tokens).exactly(3).times.and_return tokens
      expect(JWT).to receive(:decode).and_return [{'email' => email}]
    end
  end
end
