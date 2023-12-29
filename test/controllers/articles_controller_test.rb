require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
    @tagList = ["dragon", "train"]
  end

  test "get single article" do
    @article.set_tags(@tagList)
    get article_path(@article.slug), headers: { "Authorization": "Token #{encode({ user_id: @user.id })}" }
  end

  test "get multiple articles" do
    @article.set_tags(@tagList)
    get articles_path, headers: { "Authorization": "Token #{encode({ user_id: @user.id })}" }
  end
end