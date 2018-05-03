# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/' => 'welcome#index'

  get '/404'          => 'pages#not_found'
  # get '/about'        => 'pages#show_slug', slug: 'about'
  # get '/about/people' => 'pages#show_slug', slug: 'about_people'
  get '/tos'          => 'pages#show_slug', slug: 'tos',     as: :tos_page
  get '/privacy'      => 'pages#show_slug', slug: 'privacy', as: :privacy_page
  # get '/leadership'   => 'pages#leadership'
  get '/forthcoming'  => 'pages#forthcoming'

  get '/search' => 'search#index'

  mount PdfjsViewer::Rails::Engine => '/pdfjs', as: 'pdfjs'

  resources :downloads, only: [:show] do
    member do
      get :preview
    end
  end
  get '/downloads/:id/pdf_proxy(/:s3)',
      as: :pdf_proxy_download, to: 'downloads#pdf_proxy', constraints: { s3: %r{[^\/]+} }
  get '/downloads/content_guides/:id(/:slug)', as: :content_guide_pdf, to: 'content_guides#show_pdf'
  resources :explore_curriculum, only: %i(index show)
  resources :enhance_instruction, only: :index
  resources :find_lessons, only: :index
  resources :pages, only: :show
  resources :resources, only: :show do
    get :pdf_proxy, on: :collection, path: 'pdf-proxy'
  end
  resource :survey, only: %i(create show)

  get '/resources/:id/related_instruction' => 'resources#related_instruction', as: :related_instruction
  get '/media/:id' => 'resources#media', as: :media
  get '/other/:id' => 'resources#generic', as: :generic
  get '/content_guides/:id(/:slug)', as: :content_guide, to: 'content_guides#show'

  resources :documents, only: :show do
    member do
      post 'export', to: 'documents#export'
      get 'export/status', to: 'documents#export_status'
      post 'lti', to: 'documents#show_lti'
    end
  end
  resources :materials, only: :show do
    member do
      get 'preview/pdf', to: 'materials#preview_pdf'
      get 'preview/gdoc', to: 'materials#preview_gdoc'
    end
  end

  devise_for :users, class_name: 'User', controllers: { registrations: 'registrations', sessions: 'sessions' }

  authenticate :user do
    mount Resque::Server, at: '/queue'
  end

  namespace :admin do
    get '/' => 'welcome#index'
    get '/whoami' => 'admin#whoami'
    get 'google_oauth2_callback' => 'google_oauth2#callback'
    get '/association_picker' => 'association_picker#index'
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
    resources :reading_assignment_texts
    resource :resource_bulk_edits, only: %i(new create)
    get '/resource_picker' => 'resource_picker#index'
    resources :resources, except: :show do
      member do
        post :export_to_lti_cc, path: 'export-lti-cc'
        post :unit_bundle
      end
    end
    resources :download_categories, except: :show
    resources :pages, except: :show
    resources :settings, only: [] do
      patch :toggle_editing_enabled, on: :collection
    end
    resources :staff_members, except: :show
    resources :users, except: :show do
      post :reset_password, on: :member
    end
    resources :leadership_posts, except: :show
    resources :content_guide_faqs, except: :show
    resources :standards, only: %i(index edit update)

    resources :components, only: %i(index show)
    resource :sketch_compiler, path: 'sketch-compiler', only: [] do
      get '/', to: 'sketch_compilers#new', defaults: { version: 'v1' }
      get '/:version/new', to: 'sketch_compilers#new', as: :new
      post '/:version/compile', to: 'sketch_compilers#compile', as: :compile
    end
    resources :documents, except: %i(edit show update) do
      collection do
        delete :delete_selected, to: 'documents#destroy_selected'
        post :reimport_selected
        get :import_status, to: 'documents#import_status'
      end
    end
    resources :materials, except: %i(edit show update) do
      collection do
        delete :delete_selected, to: 'materials#destroy_selected'
        post :reimport_selected
        get :import_status, to: 'materials#import_status'
      end
    end
    resources :documents, only: %i(index create new destroy)
    resources :materials, only: %i(index create new destroy)
    resource :curriculum, only: %i(edit update)
    resources :access_codes
    resource :batch_reimport, only: %i(new create)
  end

  get '/ExcludeMeGA' => 'analytics_exclusion#exclude'

  get '/*slug' => 'resources#show', as: :show_with_slug
end
