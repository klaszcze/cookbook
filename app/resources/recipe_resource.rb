class RecipeResource < ApplicationResource
  attribute :title, :string
  attribute :text, :string
  attribute :difficulty, :string
  attribute :preparation_time, :integer
  attribute :created_at, :datetime

  belongs_to :author
  many_to_many :categories
end
