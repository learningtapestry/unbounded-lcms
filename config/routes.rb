Rails.application.routes.draw do
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
    scope module: :unbounded, as: :unbounded do
      get '/' => 'welcome#index'
      get '/about' => 'pages#show_slug', slug: 'about'
      get '/curriculum' => 'curriculum#index'
      get '/resources/preview' => 'lobjects#preview', as: 'resource_preview'
      get '/resources/:id' => 'lobjects#show', as: :show
      get '/search' => 'search#index'
      get '/search/curriculum' => 'search#curriculum', as: 'search_curriculum'
      get '/search/dropdown_options' => 'search#dropdown_options', as: 'dropdown_options'
      get '/tos' => 'pages#show_slug', as: :tos_page, slug: 'tos'

      namespace :admin do
        get '/' => 'welcome#index'
        resources :collection_types
        resources :collections
        resource :lobject_bulk_edits, only: [:new, :create]
        resources :lobject_children, only: :create
        resources :lobjects, except: :show
        resources :pages, except: :show
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

  root to: 'unbounded/browse#index'
end
