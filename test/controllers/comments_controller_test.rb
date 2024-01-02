require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
  end

  test "認証なしでコメントを取得できる" do
    get comments_path(@article.slug)
    assert_response :ok
  end

  test "認証ありでコメントを取得できる" do
    get comments_path(@article.slug), headers: header_token(@user)
    assert_response :ok
  end

  test "コメントのauthorにfollowingが含まれている" do
    get comments_path(@article.slug), headers: header_token(@user)
    JSON.parse(response.body)["comments"][0]["author"].key?("following")
  end
end
