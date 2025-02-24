# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipe_stats#index', type: :request do
  let(:params) { {} }
  let(:headers) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/recipe_stats', params: params, headers: headers
  end

  describe 'fetch' do
    let(:author1) { create(:author) }
    let(:author2) { create(:author) }
    let(:user1) { author1.user }
    let(:user2) { author2.user }
    let(:category1) { create(:category) }
    let(:category2) { create(:category) }
    let(:category3) { create(:category) }

    let!(:recipe1) { create(:recipe, author: author1, created_at: Date.parse('23.02.2025'), categories: [category1]) }
    let!(:recipe2) do
      create(:recipe, author: author1, created_at: Date.parse('22.02.2025'), categories: [category1, category2])
    end
    let!(:recipe3) { create(:recipe, author: author1, created_at: Date.parse('16.02.2025'), categories: [category1]) }
    let!(:recipe4) { create(:recipe, author: author1, created_at: Date.parse('01.02.2025'), categories: [category2]) }
    let!(:recipe5) do
      create(:recipe, author: author2, created_at: Date.parse('02.02.2025'), categories: [category1, category2])
    end
    let!(:recipe6) { create(:recipe, author: author1, created_at: Date.parse('01.01.2025'), categories: [category1]) }
    let!(:recipe7) { create(:recipe, author: author2, created_at: Date.parse('01.01.2025'), categories: [category1]) }

    before do
      2.times { create(:like, recipe: recipe1) }
      3.times { create(:like, recipe: recipe2) }
      create(:like, recipe: recipe4)
      2.times { create(:like, recipe: recipe5) }
      3.times { create(:like, recipe: recipe6) }
      2.times { create(:like, recipe: recipe7) }
    end

    context 'with unauthenticated user' do
      it 'return proper error' do
        make_request
        expect(response.status).to eq(401), response.body
      end
    end

    context 'with authenticated user' do
      let(:headers) { { 'Authorization': user1.token } }

      it 'returns ok status' do
        make_request
        expect(response.status).to eq 200
      end

      context 'weekly' do
        let(:params) { { group_by: 'week' } }

        it 'returns proper number of records' do
          make_request
          expect(parsed_response.size).to eq 5
        end

        it 'returns proper stats for logged user' do
          make_request
          expect(parsed_response[0]).to match({
                                                'category_name' => category1.name,
                                                'recipe_count' => 2,
                                                'total_likes' => 5,
                                                'week' => '07',
                                                'year' => '2025'
                                              })
        end
      end

      context 'monthly' do
        let(:params) { { group_by: 'monthly' } }

        it 'returns proper number of records' do
          make_request
          expect(parsed_response.size).to eq 3
        end

        it 'returns proper stats for logged user' do
          make_request
          expect(parsed_response[0]).to match({
                                                'category_name' => category1.name,
                                                'recipe_count' => 3,
                                                'total_likes' => 5,
                                                'month' => '02',
                                                'year' => '2025'
                                              })
        end
      end
    end

    context 'with authenticated other user' do
      let(:headers) { { 'Authorization': user2.token } }

      it 'returns ok status' do
        make_request
        expect(response.status).to eq 200
      end

      context 'weekly' do
        let(:params) { { group_by: 'week' } }

        it 'returns proper number of records' do
          make_request
          expect(parsed_response.size).to eq 3
        end

        it 'returns proper stats' do
          make_request
          expect(parsed_response[0]).to match({
                                                'category_name' => category1.name,
                                                'recipe_count' => 1,
                                                'total_likes' => 2,
                                                'week' => '04',
                                                'year' => '2025'
                                              })
        end
      end

      context 'monthly' do
        let(:params) { { group_by: 'monthly' } }

        it 'returns proper number of records' do
          make_request
          expect(parsed_response.size).to eq 3
        end

        it 'returns proper stats for logged user' do
          make_request
          expect(parsed_response[0]).to match({
                                                'category_name' => category1.name,
                                                'recipe_count' => 1,
                                                'total_likes' => 2,
                                                'month' => '02',
                                                'year' => '2025'
                                              })
        end
      end
    end
  end

  def parsed_response
    JSON.parse(response.body)
  end
end
