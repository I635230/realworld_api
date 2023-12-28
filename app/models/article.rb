class Article < ApplicationRecord
  belongs_to :user
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  before_save { self.slug = title.tr(" ", "-") }
  before_update { self.slug = title.tr(" ", "-") }

  validates :title, presence: true
  validates :description, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  def set_tags(tagList)
    return tags if tagList.nil?
    tagList.each do |name|
      if (tag = Tag.find_by(name: name))
      elsif (tag = Tag.new(name: name))
      end
      self.tags << tag
    end
  end

  def to_json
    { article: { slug: slug,
                 title: title,
                 description: description,
                 body: body,
                 tagList: tags.map(&:name),
                 createdAt: created_at,
                 updatedAt: updated_at,
                 favorited: favorited,
                 favoritesCount: favoritesCount,
                 author: { username: user.username,
                           bio: user.bio,
                           image: user.image } } } # followingは一旦後回し
  end
end
