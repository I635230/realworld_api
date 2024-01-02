class ApplicationController < ActionController::API
  include JwtAuthenticator

  # 認証：tokenが存在するとき、user_idを取得
  def certificated
    if auth = request.headers["Authorization"]
      @jwt_token = auth.split(" ").last
      if can_decode?(@jwt_token)
        user_id = decode(@jwt_token)["user_id"]
        @current_user = User.find_by(id: user_id)
      end
    end
  end

  # 認可：ログインしていないときにエラーを吐く
  def authorized
    if can_decode?(@jwt_token)
      render status: :unauthorized, json: { error: "Unauthorized" } unless @current_user
    else
      render status: :unauthorized, json: { error: "Unauthorized" }
    end
  end

  # ログインユーザーと記事/コメントを書いた人物が同じかを確かめる
  def correct_user(letter)
    render status: :forbidden, json: { error: "Forbidden" } unless @current_user == letter.user
  end
end
