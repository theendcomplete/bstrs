# frozen_string_literal: true

Rails.application.routes.draw do
  get 'captcha/index'
  # get 'captcha/solve'
  get 'meetings/index'
  get 'meetings/create'
  post 'meetings/create'
  post 'vk_admin/invite_user_friends'
  post 'vk_admin/create_captcha_objects'
  get 'meetings/invite'
  get 'polls/create'
  get 'polls/new'
  get 'polls/index'
  get 'invites/index'
  get 'invites/send_invite'
  get 'invites/create_invite'
  post 'send_invite/:user_id', to: 'invites#send_invite', as: :send_invite


  root 'welcome#index'

  get 'post/index'
  default_url_options host: 'theboosters.ru'
  get 'post/new'
  get 'post/show'
  get 'post/edit'
  get 'post/delete/:id', to: 'post#delete', as: 'post_delete'
  get 'post/approve/:id', to: 'post#approve_post', as: 'post_approve'
  get 'post/count_likes/:id', to: 'post#count_likes', as: 'count_likes'
  post 'captcha/solve/:id', to: 'captcha#solve', as: 'captcha_solve'
  get 'post/update_status/:id', to: 'post#update_status', as: 'post_status_update'
  get 'lk/index'
  get 'lk/vk'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'vk_admin/like_post'
  get 'vk_admin/follow_group'
  post 'vk_admin/make_like'
  post 'vk_admin/follow_group'
  post 'vk_admin/unfollow_group'
  post 'vk_admin/post_comment'
  get 'vk_admin/new_users_list'
  get 'vk_admin/new_posts_list'
  get 'vk_admin/preview_link'
  post 'vk_admin/preview_link'
  get 'welcome/index'
  get 'welcome/registered'
  get 'vk_admin/approve_user', to: 'vk_admin#approve_user'
  get 'vk_admin/invite_user/:user_id', to: 'vk_admin#invite_user', as: :invite_user

  # resources :post
  post '/post/new', to: 'post#new'
  get '/post/create', to: 'post#create'
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  match '/users/:id/finish_signup' => 'users#finish_signup', via: %i[get patch], :as => :finish_signup
end
