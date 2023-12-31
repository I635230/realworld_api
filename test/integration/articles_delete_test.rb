require "test_helper"

class ArticlesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
  end

  test "認可なしでdeleteできない" do
    delete article_path(@article.slug)
    assert_response :unauthorized
  end
  
  test "認可ありでdeleteできる" do
    delete article_path(@article.slug), headers: header_token(@user)
    assert_response :no_content
  end
end
