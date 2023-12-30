class ArticlesController < ApplicationController
  before_action :certificated, only: %i[create update delete]
  before_action :authorized, only: %i[create update delete]

  def index
    # 存在しない項目には、ワイルドカードを代入
    author = params[:author] || "%"
    tag = params[:tag] || "%"
    limit = params[:limit] || 20

    # すべてのテーブルをjoinして、絞り込みを行った結果のid
    ids = Article.joins(:user, :tags).where("users.username LIKE ?", "#{author}")
                                     .where("tags.name LIKE ?", "#{tag}")
                                     .distinct.pluck(:id)

    @articles = Article.where(id: ids).paginate(page: params[:page], per_page: limit)

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
    Article.find_by(slug: params[:slug]).delete
    render status: :ok
  end

  private
    def article_params
      params.require(:article).permit(:title, :description, :body, :favorited, :favoritesCount)
    end
end
