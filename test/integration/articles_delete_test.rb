require "test_helper"

class ArticlesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
    @other_user_article = articles(:fox)
  end

  test "認可なしで削除できない" do
    assert_no_difference "Article.count" do
      delete article_path(@article.slug)
    end
    assert_response :unauthorized
  end

  test "他人の記事を削除できない" do
    assert_no_difference "Article.count" do
      delete article_path(@other_user_article.slug), headers: header_token(@user)
    end
    assert_response :forbidden
  end

  test "自分の記事を削除できる" do
    assert_difference "Article.count", -1 do
      delete article_path(@article.slug), headers: header_token(@user)
    end
    assert_response :no_content
    assert_equal 0, @article.tags.count
    assert_equal 0, @article.comments.count
    assert_equal 0, @article.fav_users.count
  end
end
