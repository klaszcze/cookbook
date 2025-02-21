require 'rails_helper'

RSpec.describe LikeResource, type: :resource do
  describe 'creating' do
    let(:recipe) { create(:recipe) }
    let(:user) { create(:user) }
    let(:payload) do
      {
        data: {
          type: 'likes',
          relationships: {
            recipe: {
              data: { type: 'recipes', id: recipe.id }
            },
            user: {
              data: { type: 'users', id: user.id }
            }
          }
        }
      }
    end

    let(:instance) do
      LikeResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Like.count }.by(1)
    end
  end

  describe 'destroying' do
    let!(:like) { create(:like) }

    let(:instance) do
      LikeResource.find(id: like.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Like.count }.by(-1)
    end
  end
end
