require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:sakana)
  end
end

class UserCommonTest < UserTest
  test "適切な値でuserがvalidになる" do
    assert @user.valid?
  end

  # test "userをdestroyすると、articleもdestroyされる" do
  #   @user.save
  #   @user.articles.create!(content: "Lorem ipsum", title: "title", slug: "slug")
  #   assert_difference "Article.count", -1 do
  #     @user.destroy
  #   end
  # end
end

class UserNameTest < UserTest
  test "nameが存在しないとuserがinvalidになる" do
    @user.username = "   "
    assert_not @user.valid?
  end

  # test "nameの長さが長すぎるとuserがinvalidになる" do
  #   @user.username = "a" * 5111
  #   assert_not @user.valid?
  # end

  # test "既に存在する名前を保存すると、invalidになる" do
  #   @user.save
  #   @other_user = User.new(username: @user.username, email: "other@example.com", password: "foobar", password_confirmation: "foobar")
  #   assert_not @other_user.valid?
  # end

  # test "usernameにドットが含まれると、invalidになる" do
  #   @user.username = "Ex. User"
  #   assert_not @user.valid?
  # end
end

class UserEmailTest < UserTest
  test "emailが存在しないとuserがinvalidになる" do
    @user.email = "      "
    assert_not @user.valid?
  end

  # test "emailの長さが長すぎると、userがinvalidになる" do
  #   @user.email = "a" * 244 + "@example.com"
  #   assert_not @user.valid?
  # end

  # test "emailのフォーマットが間違っていると、userがinvalidになる" do
  #   invalid_addresses = %w[user@example,com # ドットの代わりにカンマを使用
  #                          user_at_foo.org # アットマークがない
  #                          user.name@example.foo@bar_baz.com # アットマークが2つ
  #                          foo@bar+baz.com # ドメイン名にプラスが入っている
  #                          user@example..com # ドットが2つ連続している
  #                          ]

  #   invalid_addresses.each do |invalid_address|
  #     @user.email = invalid_address
  #     assert_not @user.valid?, "#{invalid_address.inspect}のフォーマットエラーを検知できていません。"
  #   end
  # end

  # test "同じemailが存在すると、userはinvalidになる" do
  #   duplicate_user = @user.dup
  #   @user.save
  #   assert_not duplicate_user.valid?
  # end

  # test "emailがlowercaseとして保存されているか" do
  #   mixed_case_email = "Foo@ExamPLe.CoM"
  #   @user.email = mixed_case_email
  #   @user.save
  #   assert_equal mixed_case_email.downcase, @user.reload.email
  # end
end

class UserPasswordTest < UserTest
  # test "passwordが存在しないと、userがinvalidになる" do
  #   @user.password = " " * 6
  #   assert_not @user.valid?
  # end

  # test "passwordが短すぎると、userがinvalidになる" do
  #   @user.password = "a" * 5
  #   assert_not @user.valid?
  # end
end

class UserfollowTest < UserTest
  test "followとunfollowができる" do
    sakana = users(:sakana)
    fish = users(:fish)

    # follow
    assert_not sakana.following?(fish)
    sakana.follow(fish)
    assert sakana.following?(fish)
    assert fish.followers.include?(sakana)

    # unfollow
    sakana.unfollow(fish)
    assert_not sakana.following?(fish)
    
    # ユーザーは自分自身をフォローできない
    assert_not sakana.following?(sakana)
    sakana.follow(sakana)
    assert_not sakana.following?(sakana)
  end
end
