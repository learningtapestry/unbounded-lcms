Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/' => 'welcome#index'
  get '/about' => 'pages#show_slug', slug: 'about'
  get '/tos' => 'pages#show_slug', as: :tos_page, slug: 'tos'

  resources :explore_curriculum, only: [:index, :show]
  resources :find_lessons, only: :index
  resources :lessons, only: :show
  resources :pages, only: :show
  resources :units, only: :show

  devise_for :users, class_name: 'User', controllers: {
    registrations: 'registrations'
  }

  namespace :admin do
    get '/' => 'welcome#index'
    resources :collection_types
    resources :collections
    resource :curriculum_export, only: %i(new create)
    resource :resource_bulk_edits, only: [:new, :create]
    resources :resource_children, only: :create
    resources :resources, except: :show
    resources :pages, except: :show
    resources :staff_members, except: :show
    resources :subtitles_imports, only: [:index, :new, :create]
    resources :tags, only: :create
    resources :users, except: :show do
      post :reset_password, on: :member
    end
  end

end
