class CurrentUsersController < ApplicationController
  before_action :authorized, only: %i[show]

  def show
    @user = User.find_by(id: @user_id)
    render status: :ok, json: @user.to_json
  end
end
