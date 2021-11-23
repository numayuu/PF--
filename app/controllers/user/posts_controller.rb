class User::PostsController < ApplicationController


  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
    flash[:notice] = "記事を投稿しました！"
    redirect_to user_posts_path(@post)
    else
    render :new
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
      if @post.user != current_user
        redirect_to root_path
      end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = '更新完了しました！'
      redirect_to user_post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_post_path(post.user_id), notice: '投稿削除しました！'
  end

  def timeline
    @users = current_user.followings
    posts = Post.where(user_id: @users).order('created_at DESC')
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(9)
  end


  private
  def post_params
    params.require(:post).permit(:body, :title, :image)
  end
end
