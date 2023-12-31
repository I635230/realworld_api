require "test_helper"

class CommentsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
    @comment = comments(:yellow)
    @other_user_comment = comments(:blue)
  end

  test "認可なしで削除できない" do
    assert_no_difference "@article.comments.count" do
      delete comment_path(@article.slug, @comment.id)
    end
    assert_response :unauthorized
  end

  test "他人のコメントを削除できない" do
    assert_no_difference "@article.comments.count" do
      delete comment_path(@article.slug, @other_user_comment.id), headers: header_token(@user)
    end
    assert_response :forbidden
  end

  test "自分のコメントを削除できる" do
    assert_difference "@article.comments.count", -1 do
      delete comment_path(@article.slug, @comment.id), headers: header_token(@user)
    end
    assert_response :no_content
  end
end
