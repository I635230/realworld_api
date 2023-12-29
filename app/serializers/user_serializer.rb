class UserSerializer < ActiveModel::Serializer
  attributes %i[email token username bio image]

  def initialize(object, options = {})
    super(object, options)
    @jwt_token = options[:jwt_token]
  end

  def token
    @jwt_token
  end
end
