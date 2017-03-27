require 'spec_helper'

describe 'Yt::AuthRequest#run' do
  context 'given any valid request to a YouTube JSON API' do
    path = '/discovery/v1/apis/youtube/v3/rest'
    headers = {'User-Agent' => 'Yt::AuthRequest'}
    request = Yt::AuthRequest.new path: path, headers: headers

    it 'returns the HTTP response with the JSON-parsed body' do
      response = request.run
      expect(response).to be_a Net::HTTPOK
      expect(response.body).to be_a Hash
    end
  end
end
