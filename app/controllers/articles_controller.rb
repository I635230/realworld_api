class ArticlesController < ApplicationController
  include JwtAuthenticator

  before_action :authorized, only: %i[create]

  def create
    @user = User.find_by(id: @user_id)
    @article = @user.articles.new(article_params)
    @article.set_slug
    if @article.save
      render status: :created, json: @article.to_json
    else
      render stauts: :unprocessable_entity, json: @article.errors
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :description, :body, :favorited, :favoritesCount)
    end
end
