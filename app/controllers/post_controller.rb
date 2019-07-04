# frozen_string_literal: true

class PostController < ApplicationController
  before_action :check_current_user # , only: %i[show edit destroy update_status count_likes approve_post get_post_comments index]
  before_action :set_post, only: %i[show edit destroy update_status count_likes approve_post get_post_comments]
  before_action :check_vk_admin, only: %i[approve_post edit]
  before_action :create, only: %i[index new]

  def index
    @user_posts = current_user.posts if current_user
    @user_posts = @user_posts.paginate(page: params[:page], per_page: 5).order('created_at DESC')
  end

  def new
    @new_post = Post.new(post_params)
    if @new_post.address.split('wall').first != 'https://vk.com/'
      flash[:danger] = "Неверная ссылка! \nПравильная выглядит так: 'https://vk.com/wall*******_**' "
    else
      current_user.posts << @new_post
      if current_user.save
        flash[:success] = "Пост был успешно добавлен и ожидает модерации.\nЭто может занять какое-то время."
        PostMailer.with(user: current_user&.name, post: @new_post).new_post_email.deliver_now
      else
        mes = "Не удалось разместить пост: \n"
        @new_post.errors.full_messages.each do |message|
          p message
          mes = mes + message + "\n"
        end
        flash[:danger] = mes
      end
    end
    redirect_to post_index_path
  end

  def show;
  end

  def edit
    flash[:danger] = 'Вы не можете редактировать посты'
    redirect_to post_index_path
  end

  def delete
    @post = Post.find(params[:id])
    if current_user.posts.include? @post
      @post.destroy
      flash[:success] = 'Пост был удален'
    else
      flash[:danger] = 'Вы не можете удалить этот  пост'
    end
    redirect_to post_index_path
  end

  def update_status
    @post.update_attributes(status: 0)
    redirect_to controller: :vk_admin, action: :new_posts_list
  end

  def count_likes
    if @post
      address = @post.address
      @post.likes_count = Post.get_likes(address, current_user.vk_offline_token)
      @post.comments_count = Post.get_comments(address, current_user.vk_offline_token)
      respond_to do |format|
        format.js {render partial: 'post/result'}
      end
    else
      flash[:danger] = 'You have entered an incorrect symbol'
      redirect_to post_index_path
    end
  end

  def approve_post
    User.all.shuffle.each do |u|
      LikeVcPostJob.set(wait: rand(5..720).seconds).perform_later(u, @post.address)
    end
    @post.update_attributes(status: 3)
    flash[:success] = 'Процесс запущен и продлится не более двух часов'
    redirect_to vk_admin_new_posts_list_path
  end

  private

  def post_params
    accessible = %i[name address]
    params.require(:post).permit(accessible)
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    if @post.update(post_params)
      redirect_to @post
    else
      render :index
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def check_vk_admin
    true if current_user.vk_admin
  end

  def check_current_user
    if current_user.nil? || current_user.isBoostersMember == false
      flash[:danger] = 'У вас пока нет доступа к этой странице :('
      redirect_to root_path
    end
  end

  def create
    @new_post = Post.new
  end
end
