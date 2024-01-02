class CommentsController < ApplicationController
  before_action :certificated, only: %i[index create destroy]
  before_action :authorized, only: %i[create destroy]

  def index
    @article = Article.find_by(slug: params[:slug])
    @comments = @article.comments
    render status: :ok, json: {
      comments: ActiveModel::Serializer::CollectionSerializer.new(@comments, serializer: CommentSerializer, current_user: @current_user),
    }
  end

  def create
    @article = Article.find_by(slug: params[:slug])
    @comment = @article.comments.build(body: params[:comment][:body], user: @current_user)
    if @comment.save
      render status: :created, json: @comment, serializer: CommentSerializer, root: "comment", adapter: :json, current_user: @current_use
    else
      render status: :unprocessable_entity, json: @comment.errors
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    correct_user(@comment) and return # renderしたらreturnしないとdouble renderエラーになる
    @comment.destroy
    render status: :no_content
  end
end
