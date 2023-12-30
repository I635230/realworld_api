class UsersController < ApplicationController
  before_action :certificated, only: %i[show update]
  before_action :authorized, only: %i[show update]

  # 特定のユーザーではなく、current_userの表示のみ
  def show
    @user = User.find_by(id: @user_id)
    render status: :ok, json: @user, serializer: UserSerializer, root: "user", adapter: :json
  end

  def update
    @user = User.find_by(id: @user_id)
    if @user.update(user_params)
      render status: :created, json: @user, serializer: UserSerializer, root: "user", adapter: :json
    else
      render status: :unprocessable_entity, json: @user.errors
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render status: :created, json: @user, serializer: UserSerializer, root: "user", adapter: :json
    else
      render status: :unprocessable_entity, json: @user.errors
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :bio, :image)
    end
end
