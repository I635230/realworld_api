require "test_helper"

class UsersFavoriteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
  end

  test "認可なしでfavoriteできない" do
    assert_no_difference "@article.fav_users.count" do
      post favorite_article_path(@article.slug)
    end
    assert_response :unauthorized
  end

  test "認可なしでunfavoriteできない" do
    @user.favorite(@article)
    assert_no_difference "@article.fav_users.count" do
      delete favorite_article_path(@article.slug)
    end
    assert_response :unauthorized
  end

  test "認可ありでfavoriteできる" do
    assert_difference "@article.fav_users.count", 1 do
      post favorite_article_path(@article.slug), headers: header_token(@user)
    end
    assert_response :created
    assert_equal true, JSON.parse(response.body)["article"]["favorited"]
  end

  test "認可ありでunfavoriteできる" do
    @user.favorite(@article)
    assert_difference "@article.fav_users.count", -1 do
      delete favorite_article_path(@article.slug), headers: header_token(@user)
    end
    assert_response :ok
    assert_equal false, JSON.parse(response.body)["article"]["favorited"]
  end
end
