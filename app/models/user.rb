class User < ApplicationRecord
  validates :email, presence: true
  validates :username, presence: true
  has_secure_password

  def to_json(jwt_token = "")
    { user: { email: email,
              token: jwt_token,
              username: username,
              bio: bio,
              image: image } }
  end
end
