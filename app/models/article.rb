class Article < ApplicationRecord
  belongs_to :user
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  default_scope -> { order(created_at: :desc) }  

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
end
