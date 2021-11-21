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
    tag_list = params[:post][:tag].split(",")
    if @post.update(post_params)
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: '投稿を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user), notice: '投稿を削除しました'
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
