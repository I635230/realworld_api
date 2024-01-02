require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
    @comment = @article.comments.build(body: "body desu", user: @user)
  end

  test "適切な値でcommentがvalidになる" do
    assert @comment.valid?
  end

  test "user_idが存在しなければinvalid" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "article_idが存在しなければinvalid" do
    @comment.article_id = nil
    assert_not @comment.valid?
  end

  test "bodyが存在しなければinvalid" do
    @comment.body = "   "
    assert_not @comment.valid?
  end
end
