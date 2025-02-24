# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  def index
    likes = LikeResource.all(params.merge(filter: { user_id: current_user.id }))
    respond_with(likes)
  end

  def create
    like = Like.new(like_params)
    like.user = current_user
    like.save!

    render status: 201
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.message.match('Recipe')

    render json: { errors: ['Recipe not found'] }, status: 422
  end

  def destroy
    like = LikeResource.find(params.merge(filter: { user_id: current_user.id }))

    like.destroy
    render jsonapi: { meta: {} }, status: 200
  rescue Graphiti::Errors::RecordNotFound => e
    render json: { errors: e.message }, status: 404
  end

  private

  def like_params
    params.require(:like).permit(:recipe_id)
  end
end
