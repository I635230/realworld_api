require "test_helper"

class ArticlesPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "認可なしでpostできない" do
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: "title example",
                                               description: "description example",
                                               body: "body example",
                                               tagList: ["example_tag_1", "example_tag_2"] } }
    end
    assert_response :unauthorized
  end

  test "invalidな情報でpostできない" do
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: "",
                                               description: "",
                                               body: "" } }, 
                                               headers: header_token(@user)
    end
    assert_response :unprocessable_entity
  end

  test "validな情報でpostできる" do
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "title example",
                                               description: "description example",
                                               body: "body example",
                                               tagList: ["example_tag_1", "example_tag_2"] } },
                                               headers: header_token(@user)
    end
    assert_response :created
  end

  test "tagが空のときにpostできる" do
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "title example",
                                               description: "description example",
                                               body: "body example" } },
                                               headers: header_token(@user)
    end
    assert_response :created
  end
end
