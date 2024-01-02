require "test_helper"

class UsersRegisterTest < ActionDispatch::IntegrationTest
  test "invalidな情報でユーザー登録できない" do
    assert_no_difference "User.count" do
      post users_path, params: { user: { username: "", email: "invalid", password: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "validな情報でユーザー登録できる" do
    assert_difference "User.count", 1 do
      post users_path, params: { user: { username: "neo sakana", email: "neo_sakana@example.com", password: "password" } }
    end
    assert_response :created
  end
end
