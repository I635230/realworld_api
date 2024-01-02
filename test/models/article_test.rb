require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:sakana)
    @other_user = users(:fish)
    @article = @user.articles.build(title: "title dayo", description: "description", body: "body", slug: "title-dayo")
  end
end

class ArticleCommonTest < ArticleTest
  test "適切な値でarticleがvalidになる" do
    assert @article.valid?
  end

  test "recentが最初にこなければinvalid" do
    assert_equal articles(:recent), Article.first
  end
end

class ArticlePresenceTest < ArticleTest
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

class ArticleSlugTest < ArticleTest
  test "slugに特殊文字が存在したらinvalid" do
    invalid_symbol_array = %w[! # $ ' ( ) * + , / : ; = ? @ [ ]]
    invalid_symbol_array.each do |symbol|
      @article.title = "symbol" + symbol
      assert_not @article.valid?
    end
  end

  test "slugが存在しなければinvalid" do
    @article.title = "    " # slugはtitleから自動生成される
    assert_not @article.valid?
  end

  test "slugがuniqueでなければinvalid" do
    @article_same_slug = @user.articles.build(body: "Lorem ipsum2", description: "description", title: @article.title)
    @article.save
    assert_not @article_same_slug.valid?
  end
end

class ArtcleCommentTest < ArticleTest
  test "Articleを削除したらコメントも削除される" do
    @article.save
    @article.comments.create!(body: "comment body", user: @other_user)
    assert_difference "Comment.count", -1 do
      @article.destroy
    end
  end
end

class ArticleTagTest < ArticleTest
  test "Articleを削除したらタグの紐づけも削除される" do
    @article.save
    @article.tags.create!(name: "New Tag")
    assert_difference "ArticleTag.count", -1 do
      @article.destroy
    end
  end

  test "1つの記事に同じタグを複数設定できない" do
    @article.save
    @tag = Tag.new(name: "New Tag")
    @articletag1 = ArticleTag.new(article_id: @article.id, tag_id: @tag.id)
    @articletag1.save
    @articletag2 = ArticleTag.new(article_id: @article.id, tag_id: @tag.id)
    assert_not @articletag2.valid?
  end
end