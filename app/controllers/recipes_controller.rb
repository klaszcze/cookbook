class RecipesController < ApplicationController
  def index
    recipes = RecipeResource.all(params)
    respond_with(recipes)
  end

  def show
    recipe = RecipeResource.find(params)
    respond_with(recipe)
  end
end
