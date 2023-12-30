class ProfilesController < ApplicationController
  before_action :certificated, only: %i[show follow unfollow]
  before_action :authorized, only: %i[show follow unfollow]

  def show
    @current_user = User.find_by(id: @user_id)
    @some_user = User.find_by(username: params[:username])
    render status: :ok, json: @some_user, serializer: ProfileSerializer, root: "profile", adapter: :json, current_user: @current_user
  end

  def follow
    @current_user = User.find_by(id: @user_id)
    @some_user = User.find_by(username: params[:username])
    @current_user.follow(@some_user)
    render status: :ok, json: @some_user, serializer: ProfileSerializer, root: "profile", adapter: :json, current_user: @current_user
  end

  def unfollow
    @current_user = User.find_by(id: @user_id)
    @some_user = User.find_by(username: params[:username])
    @current_user.unfollow(@some_user)
    render status: :ok, json: @some_user, serializer: ProfileSerializer, root: "profile", adapter: :json, current_user: @current_user
  end
end
