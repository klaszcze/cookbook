# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'likes#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/likes', payload, headers: headers
  end

  describe 'basic create' do
    let(:recipe) { create(:recipe) }
    let(:params) do
      {
        recipe: {
          data: { type: 'recipes', id: recipe.id }
        }
      }
    end
    let(:payload) do
      {
        data: {
          type: 'likes',
          attributes: {},
          relationships: params
        }
      }
    end

    let(:headers) { {} }

    context 'with unauthorized user' do
      it 'returns unauthorized response' do
        make_request
        expect(response.status).to eq(401)
      end

      it 'does not create like entity' do
        expect do
          make_request
        end.not_to(change { Like.count })
      end
    end

    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:headers) { { 'Authorization': user.token } }
      it 'returns unauthorized response' do
        expect(LikeResource).to receive(:build).and_call_original
        make_request
        expect(response.status).to eq(201)
      end

      it 'does not create like entity' do
        expect do
          make_request
        end.to change { Like.count }.by(1)
      end
    end
  end
end
