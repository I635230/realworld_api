class ApplicationController < ActionController::API
  include JwtAuthenticator

  # 認証：tokenが存在するとき、user_idを取得
  def certificated
    if auth = request.headers["Authorization"]
      @jwt_token = auth.split(" ").last
      @user_id = decode(@jwt_token)["user_id"] if can_decode?(@jwt_token)
    end
  end

  # 認可：ログインしていないときにエラーを吐く
  def authorized
    if can_decode?(@jwt_token)
      render status: :unauthorized, json: { error: "Unauthorized" } unless User.find_by(id: @user_id)
    else
      render status: :unauthorized, json: { error: "Unauthorized" }
    end
  end
end
