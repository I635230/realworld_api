require "test_helper"

class ArticlesUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
  end

  test "認証なしでupdateできない" do
    put article_path(@article.slug), params: { article: { title: "neo dragon", 
                                                          description: "neo description", 
                                                          body: "neo body" } }
    assert_response :unauthorized
  end

  test "invalidな情報でupdateできない" do
    put article_path(@article.slug), params: { article: { title: "", 
                                                          description: "", 
                                                          body: "" } }, 
                                     headers: header_token(@user)
    assert_response :unprocessable_entity
  end

  test "validな情報でupdateできる" do
    put article_path(@article.slug), params: { article: { title: "neo dragon", 
                                                          description: "neo description", 
                                                          body: "neo body" } }, 
                                     headers: header_token(@user)
    assert_response :created
  end

  test "titleをupdateしたら、slugも変更される" do
    new_title = "neo dragon"
    put article_path(@article.slug), params: { article: { title: new_title, 
                                                          description: "neo description", 
                                                          body: "neo body" } }, 
                                     headers: header_token(@user)
    assert_equal new_title.tr(" ", "-"), @article.reload.slug
  end
end
