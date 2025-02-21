# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  def index
    likes = LikeResource.all(params.merge(filter: { user_id: current_user.id }))
    respond_with(likes)
  end

  def create
    like = LikeResource.build(build_like_object)

    if like.save
      render jsonapi: like, status: 201
    else
      render jsonapi_errors: like
    end
  end

  def destroy
    like = LikeResource.find(params)

    if like.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: like
    end
  end

  def build_like_object
    params[:data][:relationships][:user] = { data: { type: 'users', id: current_user.id } }
    params
  end
end
