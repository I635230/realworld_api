require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "認証なしでTagsを取得できる" do
    get tags_path
    assert_response :ok
  end

  test "認証ありでTagsを取得できる" do
    get tags_path, headers: header_token(@user)
    assert_response :ok
  end
end
