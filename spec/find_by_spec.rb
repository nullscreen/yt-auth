require 'spec_helper'

describe 'Yt::Auth.find_by' do
  context 'given an invalid refresh token' do
    invalid = 'Invalid refresh token.'

    it 'raises an error' do
      auth = Yt::Auth.find_by refresh_token: rand(36**20).to_s(36)
      expect{auth.email}.to raise_error Yt::HTTPError, invalid
    end
  end
end
