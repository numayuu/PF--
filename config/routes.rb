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


#ユーザー側
 namespace :user do
  get 'homes/about'
  resources :posts
  resources :users, only:[:index,:show,:edit,:update]
 end

 resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

 resource :searches, only: [:search] do
    get 'search'
  end

 get 'sort' => 'user/posts#sort'
end
