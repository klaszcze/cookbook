class LikeResource < ApplicationResource
  attribute :user_id, :string, filterable: :required
  belongs_to :recipe, resource: RecipeResource

  filter :user_id, :integer, required: true
end
