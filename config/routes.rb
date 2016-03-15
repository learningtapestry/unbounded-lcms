Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/' => 'welcome#index'
  get '/about' => 'pages#show_slug', slug: 'about'
  get '/tos' => 'pages#show_slug', as: :tos_page, slug: 'tos'
  get  '/search' => 'search#index'

  resources :content_guides, only: :show
  resources :explore_curriculum, only: [:index, :show]
  resources :enhance_instruction, only: :index
  resources :find_lessons, only: :index
  resources :pages, only: :show
  resources :resources, only: :show

  devise_for :users, class_name: 'User', controllers: {
    registrations: 'registrations'
  }

  namespace :admin do
    get '/' => 'welcome#index'
    get 'google_oauth2_callback' => 'google_oauth2#callback'
    resources :collection_types
    resources :collections
    resources :content_guide_definitions, only: %i(index new) do
      get :import, on: :collection
    end
    resources :content_guides, only: %i(index new) do
      collection do
        get :dangling_links
        get :import
      end
    end
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

  get '/*slug' => 'resources#show', as: :show_with_slug
end
