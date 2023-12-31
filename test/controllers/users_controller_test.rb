require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "認証なしでshowアクションにアクセスできない" do
    get user_path
    assert_response :unauthorized
  end  

  test "認証ありでshowアクションにアクセスできる" do
    get user_path, headers: header_token(@user)
    assert_response :ok
  end
end
