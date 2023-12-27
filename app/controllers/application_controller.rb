class ApplicationController < ActionController::API
  include JwtAuthenticator

  def authorized
    jwt_token = request.headers["Authorization"].split(" ").last
    if can_decode?(jwt_token)
      @user_id = decode(jwt_token)["user_id"]
      render status: :unauthorized, json: { error: "Unauthorized" } unless User.find_by(id: @user_id)
    else
      render status: :unauthorized, json: { error: "Unauthorized" }
    end
  end
end
