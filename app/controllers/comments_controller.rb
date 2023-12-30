class CommentsController < ApplicationController
  before_action :certificated, only: %i[index create delete]
  before_action :authorized, only: %i[create delete]

  def index
    @article = Article.find_by(slug: params[:slug])
    @comments = @article.comments
    render status: :ok, json: { 
      comments: ActiveModel::Serializer::CollectionSerializer.new(@comments, serializer: CommentSerializer), 
    }
  end

  def create
    @article = Article.find_by(slug: params[:slug])
    @current_user = User.find_by(id: @user_id)
    @comment = @article.comments.build(body: params[:comment][:body], user: @current_user)
    if @comment.save
      render status: :created, json: @comment, serializer: CommentSerializer, root: "comment", adapter: :json
    else
      render status: :unprocessable_entity, json: @comment.errors
    end
  end

  def destroy
    Comment.find_by(id: params[:id]).delete
    render status: :ok
  end
end
