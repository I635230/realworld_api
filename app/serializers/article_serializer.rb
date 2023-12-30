class ArticleSerializer < ActiveModel::Serializer
  attributes %i[slug title description body tagList createdAt updatedAt favorited favoritesCount]

  has_one :user, key: :author, serializer: AuthorSerializer

  def initialize(object, options = {})
    super(object, options)
    @tagFilterName = options[:tagFilterName]
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
end
