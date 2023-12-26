class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render status: :created, json: @user.to_json
    else
      render status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end