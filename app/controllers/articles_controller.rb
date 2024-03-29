class ArticlesController < ApplicationController
  before_action :certificated, only: %i[index create update destroy favorite unfavorite feed]
  before_action :authorized, only: %i[create update destroy favorite unfavorite feed]

  def index
    ids = filter_articles
    common_filter(ids)

    render status: :ok, json: {
      articles: ActiveModel::Serializer::CollectionSerializer.new(@articles, serializer: ArticleSerializer, tagFilterName: params[:tag], current_user: @current_user),
      articlesCount: @articles_all_page.size
    }
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    render status: :ok, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @current_user
  end

  def create
    @article = @current_user.articles.build(article_params)
    @article.set_tags(params[:article][:tagList])

    if @article.save
      render status: :created, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @current_user
    else
      render status: :unprocessable_entity, json: @article.errors
    end
  end

  def update
    @article = Article.find_by(slug: params[:slug])
    if @article.update(article_params)
      render status: :created, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @current_user
    else
      render status: :unprocessable_entity, json: @article.errors
    end
  end

  def destroy
    @article = Article.find_by(slug: params[:slug])
    correct_user(@article) and return
    @article.destroy
    render status: :no_content
  end

  def favorite
    @article = Article.find_by(slug: params[:slug])
    @current_user.favorite(@article)
    render status: :created, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @current_user
  end

  def unfavorite
    @article = Article.find_by(slug: params[:slug])
    @current_user.unfavorite(@article)
    render status: :ok, json: @article, serializer: ArticleSerializer, root: "article", adapter: :json, current_user: @current_user
  end

  def feed
    ids = Article.joins(:user).where("users.id IN (?)", @current_user.following.map(&:id)).map(&:id)

    common_filter(ids)
    render status: :ok, json: {
      articles: ActiveModel::Serializer::CollectionSerializer.new(@articles, serializer: ArticleSerializer, current_user: @current_user),
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
      @articles_all_page = Article.where(id: ids)
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
      ids
    end
end
