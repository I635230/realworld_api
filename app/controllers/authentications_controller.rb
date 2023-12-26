class AuthenticationsController < ApplicationController
  include JwtAuthenticator

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      jwt_token = encode({ user_id: @user.id })
      render status: :created, json: @user.to_json(jwt_token)
    else
      render status: :unauthorized, json: { error: "Unauthorized" }
    end
  end
end
