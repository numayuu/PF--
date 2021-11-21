Rails.application.routes.draw do
  root to: 'user/homes#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :users,skip: [:passwords,], controllers: {
   registrations: "user/registrations",
   sessions: 'user/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
   sessions: "admin/sessions"
  }


 namespace :user do
  #投稿用
  resources :posts
 end



end