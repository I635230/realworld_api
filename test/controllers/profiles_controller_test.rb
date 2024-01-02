require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @current_user = users(:sakana)
    @some_user = users(:fish)
  end

  test "認証なしでprofileを取得できる" do
    get profile_path(@some_user.username)
    assert_response :ok
  end

  test "認証ありでprofileを取得できる" do
    get profile_path(@some_user.username), headers: header_token(@current_user)
    assert_response :ok
  end
end
