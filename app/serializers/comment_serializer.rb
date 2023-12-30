class CommentSerializer < ActiveModel::Serializer
  attributes %i[id createdAt updatedAt body]

  has_one :user, key: :author, serializer: AuthorSerializer

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end
end
