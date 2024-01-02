class ProfileSerializer < ActiveModel::Serializer
  attributes %i[username image bio following]

  def initialize(object, options = {})
    super(object, options)
    @current_user = options[:current_user]
  end

  def following
    @current_user.nil? ? false : @current_user.following?(object)
  end
end
