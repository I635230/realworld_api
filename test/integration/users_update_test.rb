require "test_helper"

class UsersUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sakana)
  end

  test "ログインしないとupdateできない" do
    put user_path, params: { user: { username: "neo sakana", 
                                     email: "neo.sakana@example.com", 
                                     password: "qassword", 
                                     image: "https://i.stack.imgur.com/xHWG8.jpg", 
                                     bio: "I'm fish. " } }
    assert_response :unauthorized
  end

  test "invalidな情報でupdateが失敗する" do
    put user_path, headers: header_token(@user), params: { user: { username: "", 
                                                 email: "", 
                                                 password: "", 
                                                 image: "", 
                                                 bio: "" } }
    assert_response :unprocessable_entity
  end

  test "validな情報でupdateが成功する" do
    put user_path, headers: header_token(@user), params: { user: { username: "neo sakana", 
                                                 email: "neo.sakana@example.com", 
                                                 password: "qassword", 
                                                 image: "https://i.stack.imgur.com/xHWG8.jpg", 
                                                 bio: "I'm fish. " } }
    assert_response :created
  end
end
