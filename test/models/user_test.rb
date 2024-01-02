require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: "Example User", email: "hoge@example.com", password: "password", password_confirmation: "password")
  end
end

class UserCommonTest < UserTest
  test "適切な値でuserがvalidになる" do
    assert @user.valid?
  end
end

class UserNameTest < UserTest
  test "nameが存在しないとuserがinvalidになる" do
    @user.username = "   "
    assert_not @user.valid?
  end

  test "nameの長さが長すぎるとuserがinvalidになる" do
    @user.username = "a" * 5111
    assert_not @user.valid?
  end

  test "既に存在する名前を保存すると、invalidになる" do
    @user.save
    @other_user = User.new(username: @user.username, email: "other@example.com", password: "foobar", password_confirmation: "foobar")
    assert_not @other_user.valid?
  end

  test "usernameにドットが含まれると、invalidになる" do
    @user.username = "Ex. User"
    assert_not @user.valid?
  end
end

class UserEmailTest < UserTest
  test "emailが存在しないとuserがinvalidになる" do
    @user.email = "      "
    assert_not @user.valid?
  end

  test "emailの長さが長すぎると、userがinvalidになる" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "emailのフォーマットが間違っていると、userがinvalidになる" do
    invalid_addresses = %w[user@example,com # ドットの代わりにカンマを使用
                           user_at_foo.org # アットマークがない
                           user.name@example.foo@bar_baz.com # アットマークが2つ
                           foo@bar+baz.com # ドメイン名にプラスが入っている
                           user@example..com # ドットが2つ連続している
                           ]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect}のフォーマットエラーを検知できていません。"
    end
  end

  test "同じemailが存在すると、userはinvalidになる" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emailがlowercaseとして保存されているか" do
    mixed_case_email = "Foo@ExamPLe.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
end

class UserPasswordTest < UserTest
  test "passwordが存在しないと、userがinvalidになる" do
    @user.password = " " * 6
    assert_not @user.valid?
  end

  test "passwordが短すぎると、userがinvalidになる" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end
end

class UserArticleTest < UserTest
  test "Userを削除するとArticleも削除される" do
  @user.save
  @user.articles.create!(description: "description", body: "Lorem ipsum", title: "title", slug: "title")
  assert_difference "Article.count", -1 do
    @user.destroy
  end
end
end

class UserfollowTest < UserTest
  def setup
    super()
    @sakana = users(:sakana)
    @fish = users(:fish)
  end

  test "followとunfollowができる" do
    # follow
    assert_not @sakana.following?(@fish)
    @sakana.follow(@fish)
    assert @sakana.following?(@fish)
    assert @fish.followers.include?(@sakana)

    # unfollow
    @sakana.unfollow(@fish)
    assert_not @sakana.following?(@fish)

    # ユーザーは自分自身をフォローできない
    assert_not @sakana.following?(@sakana)
    @sakana.follow(@sakana)
    assert_not @sakana.following?(@sakana)
  end

  test "同じ人を2回followできない" do
    @follow1 = Relationship.new(follower_id: @sakana.id, followed_id: @fish.id)
    @follow1.save
    @follow2 = Relationship.new(follower_id: @sakana.id, followed_id: @fish.id)
    assert_not @follow2.valid?
  end

  test "Userを削除すると、Relationshipも削除される" do
    @user.save
    @user.follow(@sakana)
    assert_difference "User.count", -1 do
      @user.destroy
    end
  end
end
