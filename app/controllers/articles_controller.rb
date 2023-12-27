class ArticlesController < ApplicationController
  before_action :authorized, only: %i[create update delete]

  def show
    @article = Article.find_by(slug: params[:slug])
    render status: :ok, json: @article.to_json
  end

  def create
    @user = User.find_by(id: @user_id)
    @article = @user.articles.build(article_params)
    @article.set_tags(params[:article][:tagList])

    if @article.save
      render status: :created, json: @article.to_json
    else
      render stauts: :unprocessable_entity, json: @article.errors
    end
  end

  def update
    @article = Article.find_by(slug: params[:slug])
    if @article.update(article_params)
      render status: :created, json: @article.to_json
    else
      render status: :unprocessable_entity, json: @article.errors
    end
  end

  def destroy
    Article.find_by(slug: params[:slug]).delete
    render status: :ok
  end

  private
    def article_params
      params.require(:article).permit(:title, :description, :body, :favorited, :favoritesCount)
    end
end
