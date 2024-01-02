require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "invalidな情報でログインできない" do
    post login_path, params: { user: { email: "invalid", password: "" } }
    assert_response :unauthorized
  end

  test "validな情報でログインできる" do
    post login_path, params: { user: { email: @user.email, password: "password" } }
    assert_response :created
    res = JSON.parse(response.body)
    token = res["user"]["token"]
    assert_equal @user.id, decode(token)["user_id"]
  end
end
