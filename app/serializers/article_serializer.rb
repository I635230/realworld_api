class ArticleSerializer < ActiveModel::Serializer
  attributes %i[slug title description body tagList createdAt updatedAt favorited favoritesCount]

  has_one :user, key: :author, serializer: ProfileSerializer, current_user: @current_user

  def initialize(object, options = {})
    super(object, options)
    @tagFilterName = options[:tagFilterName]
    @current_user = options[:current_user]
  end

  def tagList
    tagList = object.tags.map(&:name)
    if @tagFilterName.nil?
      tagList
    else
      [tagList.delete(@tagFilterName)] + tagList
    end
  end

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end

  def favorited
    object.favorited?(@current_user)
  end

  def favoritesCount
    object.fav_users.count
  end
end
