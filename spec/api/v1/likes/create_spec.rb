# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'likes#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/likes', params, headers: headers
  end

  describe 'basic create' do
    let(:recipe) { create(:recipe) }
    let(:params) do
      {
        like: {
          recipe_id: recipe.id
        }
      }
    end

    let(:headers) { {} }

    context 'with unauthenticated user' do
      it 'returns unauthenticated response' do
        make_request
        expect(response.status).to eq(401)
      end

      it 'does not create like entity' do
        expect do
          make_request
        end.not_to(change { Like.count })
      end
    end

    context 'with authenticated user' do
      let(:user) { create(:user) }
      let(:headers) { { 'Authorization': user.token } }
      it 'returns created response' do
        make_request
        expect(response.status).to eq(201)
      end

      it 'does creates like entity' do
        expect do
          make_request
        end.to change { Like.count }.by(1)
      end

      context 'with invalid data' do
        let(:params) do
          {
            like: {
              recipe_id: 1010
            }
          }
        end

        it 'returns error response' do
          make_request
          expect(response.status).to eq(422)
        end

        it 'does not create like entity' do
          expect do
            make_request
          end.not_to(change { Like.count })
        end
      end
    end
  end
end
