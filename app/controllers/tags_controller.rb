class TagsController < ApplicationController
  def index
    @tags = Tag.all
    render status: :ok, json: { tags: @tags.map(&:name) }
  end
end
