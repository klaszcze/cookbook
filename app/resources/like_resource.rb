class LikeResource < ApplicationResource
  belongs_to :recipe, resource: RecipeResource
  belongs_to :user, resource: UserResource

  filter :user_id, :integer, required: true
end
