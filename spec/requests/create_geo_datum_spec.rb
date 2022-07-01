# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /geo_datum' do
  subject { post('/geo_datum', params: params, headers: headers, as: :json) }

  let!(:user) { create(:user) }

  context 'without authorization' do
    let(:params) { { input: '' } }
    let(:headers) { {} }

    it 'responds with unathorized' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with authorization' do
    let(:params) { { input: '8.8.8.8' } }
    let(:headers) { { 'Authorization' => "Basic #{Base64.encode64('user@example.com:password').strip}" } }

    it 'responds with success' do
      subject
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['success']['data']['geo']).to eq(GeoDatum.last.data)
    end
  end

  context 'with authorization and invalid input' do
    let(:params) { { input: '8.8.8.2222' } }
    let(:headers) { { 'Authorization' => "Basic #{Base64.encode64('user@example.com:password').strip}" } }

    it 'responds with success' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']['messages'].first).to eq('Invalid input')
    end
  end
end
