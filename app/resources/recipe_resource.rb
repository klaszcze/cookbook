# frozen_string_literal: true

class RecipeResource < ApplicationResource
  attribute :title, :string
  attribute :text, :string
  attribute :difficulty, :string
  attribute :preparation_time, :integer
  attribute :created_at, :datetime

  belongs_to :author
  many_to_many :categories

  filter :category_id, :integer_id do
    eq do |scope, value|
      scope
        .includes(:recipe_categories)
        .where(recipe_categories: { category_id: value })
    end
  end

  filter :category_name, :string,  only: :eq do
    eq do |scope, value|
      scope
        .includes(:categories)
        .where(categories: { name: value })
    end
  end
end
