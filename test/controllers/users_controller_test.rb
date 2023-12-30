require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "authorizedなときにshowアクションにアクセスできる" do
    get user_path, headers: header_token(@user)
    assert_response :ok
  end

  test "authorizedでないときにshowアクションにアクセスできない" do
    get user_path
    assert_response :unauthorized
  end  
end
