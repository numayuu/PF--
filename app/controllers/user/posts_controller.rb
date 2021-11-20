class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :ensure_correct_user,only:[:edit,:update,:destroy]

  def new
    @post = Post.new
    @post.post_images.build
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 投稿ページからタグを取得、,で区切って配列にする
    tag_list = params[:post][:tag].split(",")
    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: '投稿しました'
    else
      render :new
    end
  end

  def index
    # いいね順が多いに並び替え
    posts = Post.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @tags = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.includes(:user)
    @user = @post.user
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(",")
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
    params.require(:post).permit(:body)
  end
end
