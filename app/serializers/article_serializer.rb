class ArticleSerializer < ActiveModel::Serializer
  attributes %i[slug title description body tagList createdAt updatedAt favorited favoritesCount]

  has_one :user, key: :author, serializer: AuthorSerializer

  def tagList
    object.tags.map(&:name)
  end

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end
end
