require "test_helper"

class ArticlesPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "validな情報でpostできる" do
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "title example",
                                               description: "description example",
                                               body: "body example",
                                               tagList: ["example_tag_1", "example_tag_2"] } },
                                               headers: { "Authorization": "Token #{encode({ user_id: @user.id })}" }
      assert_response :created
    end
  end

  test "tagが空のときにpostできる" do
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "title example",
                                               description: "description example",
                                               body: "body example" } },
                                               headers: { "Authorization": "Token #{encode({ user_id: @user.id })}" }
      assert_response :created
    end
  end
end
