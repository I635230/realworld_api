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

  test "自分自身はfollowできない" do
    assert_not @current_user.following?(@current_user)
    post follow_profile_path(@current_user.username), headers: header_token(@current_user)
    assert_not @current_user.reload.following?(@current_user)
  end

  # TODO: 後でuserモデルのテストに移した方が良さそう
  test "followersとfollowingに適切に値が入る" do
    assert_equal [], @current_user.following
    assert_equal [], @some_user.followers
    post follow_profile_path(@some_user.username), headers: header_token(@current_user)
    assert_equal [@some_user], @current_user.reload.following
    assert_equal [@current_user], @some_user.reload.followers
    delete follow_profile_path(@some_user.username), headers: header_token(@current_user)
    assert_equal [], @current_user.reload.following
    assert_equal [], @some_user.reload.followers
  end

  # テストすると、sqliteのUNIQUE constraintでエラー吐くから多分ok
  # test "2回followしても、余計な中間テーブルが生まれない" do
  #   assert_difference "@current_user.following.size", 1 do
  #     post follow_profile_path(@some_user.username), headers: header_token(@current_user)
  #     post follow_profile_path(@some_user.username), headers: header_token(@current_user)
  #   end
  # end

  test "validな情報でfollowとunfollowできる" do
    assert_not @current_user.following?(@some_user)
    post follow_profile_path(@some_user.username), headers: header_token(@current_user)
    assert @current_user.reload.following?(@some_user)
    delete follow_profile_path(@some_user.username), headers: header_token(@current_user)
    assert_not @current_user.reload.following?(@some_user) 
  end
end
