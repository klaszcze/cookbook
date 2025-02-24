# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'likes#destroy', type: :request do
  let(:id) { like.id }
  subject(:make_request) do
    jsonapi_delete "/api/v1/likes/#{id}", headers: headers
  end

  describe 'basic destroy' do
    let!(:like) { create(:like) }

    context 'with unauthorized user' do
      let(:headers) { {} }

      it 'does not remove the resource' do
        expect do
          make_request
          expect(response.status).to eq(401), response.body
        end.not_to(change { Like.count })
      end
    end

    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:headers) { { 'Authorization': user.token } }
      let!(:like) { create(:like, user: user) }


      it 'remove the resource' do
        expect(LikeResource).to receive(:find).and_call_original
        expect do
          make_request
          expect(response.status).to eq(200), response.body
        end.to change { Like.count }.by(-1)
        expect { like.reload }
          .to raise_error(ActiveRecord::RecordNotFound)
        expect(json).to eq('meta' => {})
      end

      context 'with invalid like id' do
        let(:id) { 999 }

        it 'does not remove the resource' do
          expect do
            make_request
          end.not_to(change { Like.count })
        end

        it 'returns proper status' do
          make_request
          expect(response.status).to eq(404), response.body
        end
      end

      context 'when removing other user like' do
        let(:other_user) { create(:user) }
        let!(:other_user_like) { create(:like, user: other_user) }
        let(:id) { other_user_like.id }

        it 'does not remove the resource' do
          expect do
            make_request
          end.not_to(change { Like.count })
        end

        it 'returns proper status' do
          make_request
          expect(response.status).to eq(404), response.body
        end
      end
    end
  end
end
