class User::PostsController < ApplicationController
  def index
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  private
  def post_params
    params.require(:post).permit(:body)
  end
end
