require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
    @tagList = ["training", "dragons"]
  end

  test "Articleを取得できる" do
    @article.set_tags(@tagList)
    get article_path(@article.slug), headers: header_token(@user)
    assert_response :ok
  end

  test "get multiple articles" do
    @article.set_tags(@tagList)
    get articles_path, headers: header_token(@user)
  end

  test "offset" do
    get articles_path({offset: 2}), headers: header_token(@user)
  end
end