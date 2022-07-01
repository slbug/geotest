# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /geo_datum' do
  subject { get('/geo_datum', params: params.merge(format: :json), headers: headers) }

  let!(:user) { create(:user) }
  let!(:geo_datum) { create(:geo_datum) }

  context 'without authorization' do
    let(:params) { { input: '' } }
    let(:headers) { {} }

    it 'responds with unathorized' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with authorization' do
    let(:params) { { input: '1.1.1.1' } }
    let(:headers) { { 'Authorization' => "Basic #{Base64.encode64('user@example.com:password').strip}" } }

    it 'responds with success' do
      subject
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['success']['data']['geo']).to eq(geo_datum.data)
    end
  end

  context 'with authorization and invalid input' do
    let(:params) { { input: '8.8.8.2222' } }
    let(:headers) { { 'Authorization' => "Basic #{Base64.encode64('user@example.com:password').strip}" } }

    it 'responds with success' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end
end
