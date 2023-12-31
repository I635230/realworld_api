class ArticlesController < ApplicationController
  before_action :certificated, only: %i[create update destroy favorite unfavorite feed]
  before_action :authorized, only: %i[create update destroy favorite unfavorite feed]

  def index
    ids = filter_articles
    common_filter(ids)

    render status: :ok, json: { 
      articles: ActiveModel::Serializer::CollectionSerializer.new(@articles, serializer: ArticleSerializer, tagFilterName: params[:tag]), 
      articlesCount: @articles.size
    }
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    render status: :ok, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json
  end

  def create
    @user = User.find_by(id: @user_id)
    @article = @user.articles.build(article_params)
    @article.set_tags(params[:article][:tagList])

    if @article.save
      render status: :created, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json
    else
      render status: :unprocessable_entity, json: @article.errors
    end
  end

  def update
    @article = Article.find_by(slug: params[:slug])
    if @article.update(article_params)
      render status: :created, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json
    else
      render status: :unprocessable_entity, json: @article.errors
    end
  end

  def destroy
    @article = Article.find_by(slug: params[:slug])
    @current_user = User.find_by(id: @user_id)
    correct_user(@article) and return
    @article.destroy
    render status: :no_content
  end

  def favorite
    @user = User.find_by(id: @user_id)
    @article = Article.find_by(slug: params[:slug])
    @user.favorite(@article)
    render status: :created, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @user
  end

  def unfavorite
    @user = User.find_by(id: @user_id)
    @article = Article.find_by(slug: params[:slug])
    @user.unfavorite(@article)
    render status: :ok, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @user
  end

  def feed
    @user = User.find_by(id: @user_id)
    ids = Article.joins(:user).where("users.id IN (?)", @user.following.map(&:id)).map(&:id)

    common_filter(ids)
    render status: :ok, json: { 
      articles: ActiveModel::Serializer::CollectionSerializer.new(@articles, serializer: ArticleSerializer), 
      articlesCount: @articles.size
    }
  end

  private
    def article_params
      params.require(:article).permit(:title, :description, :body)
    end

    def common_filter(ids)
      limit = params[:limit] || 20
      offset = params[:offset].to_i || 0

      # オフセット
      ids = ids.slice(offset..-1)

      # ページネーション
      @articles = Article.where(id: ids).paginate(page: params[:page], per_page: limit)
    end

    def filter_articles
      if !params[:author].nil?
        ids = Article.joins(:user).where("users.username LIKE ?", "#{params[:author]}").map(&:id)
      elsif !params[:tag].nil?
        ids = Article.joins(:tags).where("tags.name LIKE ?", "#{params[:tag]}").map(&:id)
      elsif !params[:favorited].nil?
        ids = Article.joins(:favorites).where("favorites.user_id LIKE ?", "#{User.find_by(username: params[:favorited]).id}").map(&:id)
      else
        ids = Article.all.map(&:id)
      end
    end
end
