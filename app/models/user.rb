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
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fav_articles, through: :favorites, source: :article

  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  VALID_USERNAME_REGEX = /\A[^.]+\z/
  validates :username, presence: true,
                      length: { maximum: 50 },
                      format: { with: VALID_USERNAME_REGEX },
                      uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

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

  # favorite関係のメソッド
  def favorite(article)
    fav_articles << article
  end

  def unfavorite(article)
    fav_articles.delete(article)
  end

  def favorite?(article)
    fav_articles.include?(article)
  end
end
