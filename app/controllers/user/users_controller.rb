class User::UsersController < ApplicationController

  def index
    @user = current_user
    @users = User.all
    @post = Post.new
    @posts = Post.all
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = Post.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
     if @user != current_user
       redirect_to root_path(current_user)
     end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice]="You have updated user successfully."
      redirect_to root_path(current_user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

end
