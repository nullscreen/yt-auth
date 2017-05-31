require 'spec_helper'

describe 'Yt::Auth#access_token' do
  context 'not given any authorization code' do
    missing = 'Missing required parameter: code'

    it 'raises an error (missing code)' do
      auth = Yt::Auth.new
      expect{auth.access_token}.to raise_error Yt::HTTPError, missing
    end
  end

  context 'given an invalid authorization code' do
    invalid = 'Invalid authorization code.'

    it 'raises an error (invalid or already redeemed)' do
      auth = Yt::Auth.new code: rand(36**20).to_s(36)
      expect{auth.access_token}.to raise_error Yt::HTTPError, invalid
    end
  end

  context 'given a valid authorization code' do
    access_token = 'ya29.GltbBLXt74GrwX8S_xr70aX'
    auth = Yt::Auth.new code: 'valid'

    it 'returns a valid access_token' do
      expect(auth.access_token).to eq access_token
    end

    # NOTE: This test needs to be mocked because getting a real authorization
    # code requires a web interaction from a real user.
    before do
      expect(auth).to receive(:tokens).and_return 'access_token' => access_token
    end
  end
end
