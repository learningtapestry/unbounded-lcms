Rails.application.routes.draw do
  anything_goes = /[^\/]+/

  devise_for :users, class_name: 'Content::Models::User'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  get '/api/v1/resources' => 'api#show_resources'
  get '/api/v1/alignments' => 'api#show_alignments'
  get '/api/v1/subjects' => 'api#show_subjects'
  get '/api/v1/identities' => 'api#show_identities'


  if ENV['CONTENT_ROOT_WEBSITE'] == 'unbounded'
    root to: 'unbounded/welcome#index'
    
    scope module: :unbounded, as: :unbounded do
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
      get '/resources/:id/preview' => 'lobjects#preview', as: 'resource_preview'
      get '/resources/:id' => 'lobjects#show', as: :show
      get '/resources/*slug' => 'lobjects#show', as: :show_with_slug
      get '/search' => 'search#index'
      get '/tos' => 'pages#show_slug', as: :tos_page, slug: 'tos'

      namespace :admin do
        get '/' => 'welcome#index'
        resources :collection_types
        resources :collections
        resource :lobject_bulk_edits, only: [:new, :create]
        resources :lobject_children, only: :create
        resources :lobjects, except: :show
        resources :pages, except: :show
        resources :staff_members, except: :show
        resources :tags, only: :create
      end

      resources :pages, only: :show
    end
  end

  namespace :lt do
    namespace :admin do
      get '/' => 'welcome#index'
      get '/synonyms' => 'synonyms#edit', as: :edit_synonyms
      post '/synonyms' => 'synonyms#update'
    end
  end

end
