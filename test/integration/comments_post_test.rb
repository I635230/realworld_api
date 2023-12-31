require "test_helper"

class CommentsPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
    @other_user_article = articles(:fox)
  end

  test "認可なしでコメントできない" do
    assert_no_difference "@article.comments.count" do
      post comments_path(@article.slug)
    end
    assert_response :unauthorized
  end

  test "自分の記事にコメントできる" do
    assert_difference "@article.comments.count", 1 do
      post comments_path(@article.slug), params: { comment: { body: "コメントだよー" } }, headers: header_token(@user)
    end
    assert_response :created
  end
  
  test "他人の記事にコメントできる" do
    assert_difference "@other_user_article.comments.count", 1 do
      post comments_path(@other_user_article.slug), params: { comment: { body: "コメントだよー" } }, headers: header_token(@user)
    end
    assert_response :created
  end
end
