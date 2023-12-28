class ProfilesController < ApplicationController

  before_action :authorized, only: %i[show follow unfollow]

  def show
    @current_user = User.find_by(id: @user_id)
    @some_user = User.find_by(username: params[:username])
    render status: :ok, json: @some_user.to_profile(@current_user)
  end

  def follow
    @current_user = User.find_by(id: @user_id)
    @some_user = User.find_by(username: params[:username])
    @current_user.follow(@some_user)
    render status: :ok, json: @some_user.to_profile(@current_user)
  end

  def unfollow
    @current_user = User.find_by(id: @user_id)
    @some_user = User.find_by(username: params[:username])
    @current_user.unfollow(@some_user)
    render status: :ok, json: @some_user.to_profile(@current_user)
  end
end
