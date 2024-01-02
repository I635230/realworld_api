require "test_helper"

class UsersFollowTest < ActionDispatch::IntegrationTest
  def setup
    @current_user = users(:sakana)
    @some_user = users(:fish)
  end

  test "認可なしでfollowできない" do
    post follow_profile_path(@some_user.username)
    assert_response :unauthorized
    assert_not @current_user.reload.following?(@some_user)
  end

  test "認可なしでunfollowできない" do
    post follow_profile_path(@some_user.username), headers: header_token(@current_user)
    delete follow_profile_path(@some_user.reload.username)
    assert_response :unauthorized
    assert @current_user.reload.following?(@some_user)
  end

  test "validな情報でfollowとunfollowできる" do
    assert_not @current_user.following?(@some_user)
    post follow_profile_path(@some_user.username), headers: header_token(@current_user)
    assert @current_user.reload.following?(@some_user)
    delete follow_profile_path(@some_user.username), headers: header_token(@current_user)
    assert_not @current_user.reload.following?(@some_user) 
  end
end
