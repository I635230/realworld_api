require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:sakana)
    @article = articles(:dragon)
  end
end

class ArticleCommonTest < ArticleTest
  test "適切な値でarticleがvalidになる" do
    assert @article.valid?
  end
end

class PresenceTest < ArticleTest
  test "user_idが存在しなければinvalid" do
    @article.user_id = nil
    assert_not @article.valid?
  end

  test "titleが存在しなければinvalid" do
    @article.title = "   "
    assert_not @article.valid?
  end

  test "descriptionが存在しなければinvalid" do
    @article.description = "    "
    assert_not @article.valid?
  end

  test "bodyが存在しなければinvalid" do
    @article.body = "    "
    assert_not @article.valid?
  end
end

# class SlugTest < ArticleTest
#   test "slugに特殊文字が存在したらinvalid" do
#     invalid_symbol_array = %w[! # $ ' ( ) * + , / : ; = ? @ [ ]]
#     invalid_symbol_array.each do |symbol|
#       @article.slug = symbol
#       assert_not @article.valid?
#     end
#   end

#   test "slugが存在しなければinvalid" do
#     @article.slug = "    "
#     assert_not @article.valid?
#   end

#   test "slugがuniqueでなければinvalid" do
#     @article_same_slug = @user.articles.build(content: "Lorem ipsum2", title: "title2", slug: "title-dayo")
#     @article.save
#     assert_not @article_same_slug.valid?
#   end
# end
