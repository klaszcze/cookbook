# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'likes#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/likes', params: params, headers: headers
  end

  describe 'basic fetch' do
    let(:user) { create(:user) }
    let!(:like1) { create(:like) }
    let!(:like2) { create(:like, user: user) }
    let!(:like3) { create(:like, user: user) }

    context 'with unauthorized user' do
      let(:headers) { {} }

      it 'return proper error' do
        expect do
          make_request
          expect(response.status).to eq(401), response.body
        end
      end
    end

    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:headers) { { 'Authorization': user.token } }

      it 'returns only users likes' do
        expect(LikeResource).to receive(:all).and_call_original
        make_request
        expect(response.status).to eq(200), response.body
        expect(d.map(&:jsonapi_type).uniq).to match_array(['likes'])
        expect(d.map(&:id)).to match_array([like2.id, like3.id])
      end
    end
  end
end
