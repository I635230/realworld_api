class AuthenticationsController < ApplicationController
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      jwt_token = encode({ user_id: @user.id })
      render status: :created, json: @user, serializer: UserSerializer, root: "user", adapter: :json, jwt_token: jwt_token
    else
      render status: :unauthorized, json: { error: "Unauthorized" }
    end
  end
end
