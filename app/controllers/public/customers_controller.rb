class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, except: %i[index show guest_sign_in]
  before_action :set_customer, only: [:favorites]
  before_action :authorize_customer, only: %i[edit update]
  before_action :ensure_guest_customer, only: [:edit]

  def index
    # 新規登録失敗時に画面をリロードすると新規登録画面に遷移する
    redirect_to new_customer_registration_path
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.order(created_at: :desc).page(params[:page]).per(6)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(@customer.id), notice: '編集を保存しました'
    else
      render :edit
    end
  end

  def destroy
    customer = Customer.find(params[:id])
    customer.destroy
    redirect_to root_path, notice: '退会に成功しました'
  end

  def favorites
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id)
    if favorites.present?
      @favorite_posts = Post.where(id: favorites).page(params[:page]).per(6)
    else
      # いいねした投稿がなかった時何も表示しない
      @favorite_posts = []
    end
  end

  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to customer_path(customer), notice: 'ゲストでログインしました'
  end

  private

  def customer_params
    params.require(:customer).permit(%i[image first_name last_name nickname phone_number email profile])
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def authorize_customer
    @customer = Customer.find(params[:id])
    unless current_customer == @customer
      redirect_to root_path, alert: '他のユーザーの編集はできません'
    end
  end

  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.email == "guest@example.com"
      redirect_to customer_path(current_customer), alert: 'ゲストユーザーはプロフィール編集画面へ遷移できません'
    end
  end
end