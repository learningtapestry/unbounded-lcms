Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/' => 'welcome#index'

  get '/404'          => 'pages#not_found'
  get '/about'        => 'pages#show_slug', slug: 'about'
  get '/about/people' => 'pages#show_slug', slug: 'about_people'
  get '/tos'          => 'pages#show_slug', slug: 'tos',     as: :tos_page
  get '/privacy'      => 'pages#show_slug', slug: 'privacy', as: :privacy_page
  get '/leadership'   => 'pages#leadership'

  get '/search' => 'search#index'

  mount PdfjsViewer::Rails::Engine => '/pdfjs', as: 'pdfjs'

  resources :downloads, only: [:show] do
    member do
      get :preview
    end
  end
  get '/downloads/:id/pdf_proxy(/:s3)', as: :pdf_proxy_download, to: 'downloads#pdf_proxy'
  get '/downloads/content_guides/:id(/:slug)', as: :content_guide_pdf, to: 'content_guides#show_pdf'
  resources :explore_curriculum, only: [:index, :show]
  resources :enhance_instruction, only: :index
  resources :find_lessons, only: :index
  resources :pages, only: :show
  resources :resources, only: :show

  get '/resources/:id/related_instruction' => 'resources#related_instruction', as: :related_instruction
  get '/media/:id' => 'resources#media', as: :media
  get '/other/:id' => 'resources#generic', as: :generic
  get '/content_guides/:id(/:slug)', as: :content_guide, to: 'content_guides#show'

  devise_for :users, class_name: 'User', controllers: {
    registrations: 'registrations'
  }

  namespace :admin do
    get '/' => 'welcome#index'
    get 'google_oauth2_callback' => 'google_oauth2#callback'
    get '/association_picker' => 'association_picker#index'
    resources :collection_types
    resources :collections
    resources :content_guide_definitions, only: %i(index new) do
      get :import, on: :collection
    end
    resources :content_guides, except: :create do
      collection do
        get :import
        get :links_validation
        post :reset_pdfs
      end
    end
    resource :curriculum_export, only: %i(new create)
    resources :curriculums
    resources :reading_assignment_texts
    resource :resource_bulk_edits, only: [:new, :create]
    resources :resource_children, only: :create
    get '/resource_picker' => 'resource_picker#index'
    get '/curriculum_picker' => 'resource_picker#curriculum'
    resources :resources, except: :show
    resources :download_categories, except: :show
    resources :pages, except: :show
    resources :settings, only: [] do
      patch :toggle_editing_enabled, on: :collection
    end
    resources :staff_members, except: :show
    resources :tags, only: :create
    resources :users, except: :show do
      post :reset_password, on: :member
    end
    resources :leadership_posts, except: :show
    resources :content_guide_faqs, except: :show
  end

  get '/*slug' => 'resources#show', as: :show_with_slug
end
