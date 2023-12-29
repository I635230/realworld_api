class AuthorSerializer < ActiveModel::Serializer
  attributes %i[username bio image]
end
