Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'landing#index', as: :root

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :sharing do
        resources :folders, only: [:index, :show]
      end
      resources :users, only: [:index]
      resources :accumulated_users_by_month, only: [:index]
      resources :binary_downloads, only: [:index]
      resources :binary_downloads_by_date, only: [:index]
      resources :binary_downloads_public_v_private, only: [:index]
      resources :binaries_by_type, only: [:index]
    end
  end

  get '/auth/facebook', as: :facebook_login
  get '/auth/facebook/callback', to: "sessions#create", as: :facebook_callback

  get 'dropbox/auth' => 'dropbox#auth'
  get 'dropbox/auth_callback' => 'dropbox#auth_callback'
  post 'dropbox/upload_file' => 'dropbox#upload_file'

  namespace :admin do
    get '/dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :update]
  end


  resources :confirmations, only: [:new, :create]
  resources :sessions, only: [:create]

  get '/sign_up', to: 'sign_up#new'
  post '/sign_up', to: 'sign_up#create'
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :public_folders, only: [:index, :show]

  namespace :public_folders do
    resources :binaries, only: [:show]
  end

  resources :binary_downloads, only: [:new]

  namespace :users, path: ":username" do

    get '/dashboard', to: 'users#show', as: :dashboard
    get '/dashboard/edit', to: 'users#edit', as: :dashboard_edit
    patch '/dashboard/edit', to: 'users#update', as: :dashboard_patch

    get '/dashboard/change_password', to: 'passwords#reset', as: :password_reset
    patch '/dashboard/change_password/update', to: 'passwords#update', as: :password_patch
    get '/dashboard/change_password/edit', to: 'passwords#edit', as: :password_edit

    get '/shared_folders', to: 'shared_folders#index', as: :shared_folders

    get '/*route/share', to: 'folders/invites#new', as: :folder_new_share
    get '/*route/share_accept', to: 'folders/invites#show', as: :folder_share_accept
    post '/*route/share', to: 'folders/shares#create'
    post '/*route/invitation', to: 'folders/invites#create', as: :folder_new_share_invitation

    get '/*route/folder_new', to: 'folders#new', as: :new_folder
    get '/*route/:binary_name', to: 'folders/binaries#show', as: :binary, format: true

    post '/*route/:binary_name/like', to: 'folders/binaries/file_likes#create', as: :like_file, format: true
    post '/*route/:binary_name/dislike', to: 'folders/binaries/file_likes#delete', as: :dislike_file, format: true
    post '/*route/:binary_name/like_comment', to: 'folders/binaries/comment_likes#create', as: :like_comment

    get '/*route/binary_new', to: 'folders/binaries#new', as: :new_binary
    post '/*route', to: 'folders/binaries#create', as: :binaries, constraints: { parameters: /binary/ }
    delete '/*route/:binary_name', to: 'folders/binaries#destroy', format: true, as: :binary_delete

    post '/*route', to: 'folders#create', as: :folders, constraints: { parameters: /folder/ }
    delete '/*route', to: 'folders#destroy', as: :folder_delete
    post '/*route/:binary_name', to: 'folders/binaries/comments#create', as: :binary_comments, format: true

    get '/*route', to: 'folders#show', as: :folder
    get '/', to: 'users#show'
  end

end
