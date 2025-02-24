# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipes#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/recipes', params: params
  end

  describe 'basic fetch' do
    let!(:recipe1) { create(:recipe) }
    let!(:recipe2) { create(:recipe) }

    it 'returns proper response' do
      expect(RecipeResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['recipes'])
      expect(d.map(&:id)).to match_array([recipe1.id, recipe2.id])
    end
  end

  describe 'filter by category_id' do
    let!(:recipe1) { create(:recipe) }
    let!(:recipe2) { create(:recipe) }
    let!(:recipe3) { create(:recipe) }
    let!(:category1) { create(:category) }
    let!(:category2) { create(:category) }

    let(:params) { { filter: { category_id: { eq: category1.id } } } }

    before do
      recipe1.categories << category1
      recipe3.categories << [category1, category2]
    end

    it 'returns filtered response' do
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['recipes'])
      expect(d.map(&:id)).to match_array([recipe1.id, recipe3.id])
    end
  end

  describe 'filter by category_name' do
    let!(:recipe1) { create(:recipe) }
    let!(:recipe2) { create(:recipe) }
    let!(:recipe3) { create(:recipe) }
    let!(:category1) { create(:category, name: 'Mexican') }
    let!(:category2) { create(:category, name: 'Vegetarian') }

    let(:params) { { filter: { category_name: { eq: 'Vegetarian' } } } }

    before do
      recipe1.categories << category1
      recipe3.categories << [category1, category2]
    end

    it 'returns filtered response' do
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['recipes'])
      expect(d.map(&:id)).to match_array([recipe3.id])
    end
  end
end
