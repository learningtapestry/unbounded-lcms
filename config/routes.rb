Rails.application.routes.draw do
  root to: 'welcome#index'

  anything_goes = /[^\/]+/

  devise_for :users, class_name: 'User', controllers: {
    registrations: 'registrations'
  }

  get '/' => 'welcome#index'
  get '/about' => 'pages#show_slug', slug: 'about'
  get '/curriculum/highlights' => 'curriculum#highlights', as: 'curriculum_highlights'
  get '/curriculum(/:subject(/:grade(/:standards)))' => 'curriculum#index',
    as: 'curriculum',
    constraints: {
      subject: anything_goes,
      grade: anything_goes,
      standards: anything_goes
    }
  get '/professional_development' => 'pages#show_slug', as: :pd, slug: 'professional_development'
  get '/resources/:id/preview' => 'resources#preview', as: 'resource_preview'
  get '/resources/:id' => 'resources#show', as: :show
  get '/resources/*slug' => 'resources#show', as: :show_with_slug
  get '/search' => 'search#index'
  get '/tos' => 'pages#show_slug', as: :tos_page, slug: 'tos'

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

  resources :pages, only: :show
  resources :find_lessons, only: :index

end
