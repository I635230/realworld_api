class Article < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :slug, presence: true
  validates :description, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  def set_slug
    self.slug = title.tr(" ", "-")
  end

  def to_json(tagList = [])
    { article: { slug: slug,
                 title: title,
                 description: description,
                 body: body,
                 tagList: tagList,
                 createdAt: created_at,
                 updatedAt: updated_at,
                 favorited: favorited,
                 favoritesCount: favoritesCount,
                 author: { username: user.username,
                           bio: user.bio,
                           image: user.image } } } # followingは一旦後回し
  end
end
