class ProfilesController < ApplicationController
  before_action :certificated, only: %i[show follow unfollow]
  before_action :authorized, only: %i[follow unfollow]

  def show
    @some_user = User.find_by(username: params[:username])
    render status: :ok, json: @some_user, serializer: ProfileSerializer, root: "profile", adapter: :json, current_user: @current_user
  end

  def follow
    @some_user = User.find_by(username: params[:username])
    @current_user.follow(@some_user)
    render status: :ok, json: @some_user, serializer: ProfileSerializer, root: "profile", adapter: :json, current_user: @current_user
  end

  def unfollow
    @some_user = User.find_by(username: params[:username])
    @current_user.unfollow(@some_user)
    render status: :ok, json: @some_user, serializer: ProfileSerializer, root: "profile", adapter: :json, current_user: @current_user
  end
end
