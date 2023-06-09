class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit

  end

  def create
    @post = Post.new(post_params)
    # @post.customer_id = current_customer.id
    @post.save
    redirect_to 'show'
  end

  def destroy

  end

  def update

  end

  private
  def post_params
    params.require(:post).permit(%i[image post_name introduction address])
  end
end