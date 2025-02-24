class RecipeStatsController < ApplicationController
  before_action :authenticate_user!

  def index
    stats = RecipeStatsQuery.new.get_stats(author: current_user, group_by: params[:group_by])

    render json: stats
  end
end
