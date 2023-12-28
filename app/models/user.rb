class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :active_relationships,  class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

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

  def to_profile(current_user)
    { profile: { username: username, 
                 bio: bio, 
                 image: image, 
                 following: current_user.nil? ? false : current_user.following?(self) } }
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # follow関係のメソッド
  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
