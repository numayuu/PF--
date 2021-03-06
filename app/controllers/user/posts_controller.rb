class User::PostsController < ApplicationController
  before_action :authenticate_user!
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      @post.post_images_images.each do |image|
        tags = Vision.get_image_data(image)
        tags.each do |tag|
          @post.tags.create(name: tag, post_id: @post.id)
        end
      end
      flash[:notice] = "記事を投稿しました！"
      redirect_to user_post_path(@post)
    else
      render :new
    end
  end

  def index
    @posts = Post.all
    @posts = @posts.page(params[:page]).per(10)
    @tag = Tag.all              #ビューでタグ一覧を表示するために全取得。
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.includes(:user)
    @user = @post.user
    @post_comment = PostComment.new
    @post = Post.find(params[:id])  #クリックした投稿を取得。
    @post_tags = @post.tags         #そのクリックした投稿に紐付けられているタグの取得。
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
    redirect_to user_posts_path, notice: '投稿削除しました！'
  end

  def search
    # @tag_list = Tag.all  #こっちの投稿一覧表示ページでも全てのタグを表示するために、タグを全取得
    @tag_posts = Tag.where(name: params[:tag_name])  #クリックしたタグを取得
    # @posts = @tag.posts.all           #クリックしたタグに紐付けられた投稿を全て表示
    # binding.irb
    @tag_posts = Kaminari.paginate_array(@tag_posts).page(params[:page]).per(10)
  end




  private
  def post_params
    params.require(:post).permit(:body, :title, :image, post_images_images:[])
  end
end
