require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
  end
end

class SingleArticleTest < ArticlesControllerTest
  test "Articleを取得できる" do
    get article_path(@article.slug), headers: header_token(@user)
    assert_response :ok
  end
end

class MultiArticleTest < ArticlesControllerTest
  test "Articleの配列を取得できる" do
    get articles_path, headers: header_token(@user)
    assert_response :ok
  end

  test "TagFileterが機能している" do
    get articles_path({tag: "dragons"}), headers: header_token(@user)
    assert_response :ok
    JSON.parse(response.body)["articles"].each do |article|
      assert article["tagList"].include?("dragons")
    end
  end

  test "AuthorFilterが機能している" do
    get articles_path({author: "sakana"}), headers: header_token(@user)
    assert_response :ok
    JSON.parse(response.body)["articles"].each do |article|
      assert_equal "sakana", article["author"]["username"]
    end
  end

  test "FavoriteFilterが機能している" do
    get articles_path({favorited: "sakana"}), headers: header_token(@user)
    assert_response :ok
    assert_equal Favorite.count, JSON.parse(response.body)["articlesCount"]
  end

  test "Limitが機能している" do
    get articles_path({limit: 1}), headers: header_token(@user)
    assert_response :ok
    assert_equal 1, JSON.parse(response.body)["articles"].size
  end

  test "Offsetが機能している" do
    get articles_path, headers: header_token(@user)
    slug1 = JSON.parse(response.body)["articles"][1]["slug"]
    get articles_path({offset: 1}), headers: header_token(@user)
    assert_response :ok
    slug2 = JSON.parse(response.body)["articles"][0]["slug"]
    assert_equal slug1, slug2
  end
end

class FeedArticlesTest < ArticlesControllerTest
  test "Feed Articleを取得できる" do
    get feed_articles_path, headers: header_token(@user)
    assert_response :ok
    JSON.parse(response.body)["articles"].each do |article|
      assert_equal "uo", article["author"]["username"]
    end
  end

  test "Limitが機能している" do
    get feed_articles_path({limit: 1}), headers: header_token(@user)
    assert_response :ok
    assert_equal 1, JSON.parse(response.body)["articles"].size
  end

  test "Offsetが機能している" do
    get feed_articles_path, headers: header_token(@user)
    slug1 = JSON.parse(response.body)["articles"][1]["slug"]
    get feed_articles_path({offset: 1}), headers: header_token(@user)
    assert_response :ok
    slug2 = JSON.parse(response.body)["articles"][0]["slug"]
    assert_equal slug1, slug2
  end
end