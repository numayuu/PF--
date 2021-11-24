class User::HomesController < ApplicationController
  def top
    @posts = Post.all
    @user = current_user
  end

  def about
    @posts = Post.all
    @user = current_user
  end
end
