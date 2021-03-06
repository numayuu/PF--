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
  get 'posts/search'
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

 resources :contacts, only: [:new, :create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'done', to: 'contacts#done', as: 'done'

end
