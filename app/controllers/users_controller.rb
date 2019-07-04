# frozen_string_literal: true

require 'cgi'

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]


  # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, bypass: true)
        format.html {redirect_to @user, notice: 'Your profile was successfully updated.'}
        format.json {head :no_content}
      else
        format.html {render action: 'edit'}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] # && params[:user][:email]
      # if @user.update(user_params)
      extract = CGI.parse(params[:user][:vk_offline_token])
      params[:user][:vk_offline_token] = extract['https://oauth.vk.com/blank.html#access_token'][0]

      if current_user.update(user_params)
        # @user.skip_reconfirmation!
        bypass_sign_in(current_user)
        if params[:vk_community]
          @vk_com = find_or_create_vk_community(params[:vk_community])
        end
        User.add_vkcommunity_to_user(current_user, @vk_com)
        if current_user.roles.empty? && !Role.all.empty?
          current_user.roles << Role.all.first
        end
        flash[:success] = 'Your profile was successfully updated.'
        redirect_to root_path
      else
        flash[:error] = '  ' + current_user.errors.full_messages.to_sentence
        # @show_errors = true
        redirect_to root_path
      end
      # else
      # if User.check_user_vk_membership(current_user)
      #   redirect_to root_path
      # else
      #   current_user.vk_offline_token = '0'
      #   current_user.save
      #   redirect_to finish_signup_path(current_user)
      # end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html {redirect_to root_url}
      format.json {head :no_content}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def find_or_create_vk_community(vk_c)
    Vcommunity.find_or_create_by_addr(current_user, vk_c)
  end

  def user_params
    accessible = %i[name vk_offline_token vk_com] # extend with your own params
    accessible << %i[password password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
