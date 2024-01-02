class CommentSerializer < ActiveModel::Serializer
  attributes %i[id createdAt updatedAt body]

  has_one :user, key: :author, serializer: ProfileSerializer, current_user: @current_user

  def initialize(object, options = {})
    super(object, options)
    @current_user = options[:current_user]
  end

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end
end
