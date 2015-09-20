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

  namespace :unbounded do
    get '/' => 'browse#index'
    get '/search' => 'browse#search'
    get '/show/:id' => 'browse#show', as: :show
    get '/home' => 'browse#home'
    get '/search_new' => 'browse#search_new'
    get '/show_new/:id' => 'browse#show_new', as: :show_new

    namespace :admin do
      get '/' => 'welcome#index'

      resources :collection_types, except: :destroy

      resources :collections

      resources :lobject_children, only: :create

      resources :lobjects, except: [:index, :show, :destroy] do
        get :delete, action: :destroy, on: :member
      end

      resources :pages, except: :show
    end

    resources :pages, only: :show
  end

  namespace :admin do
    get '/' => 'welcome#index'
    get '/synonyms' => 'synonyms#edit', as: :edit_synonyms
    post '/synonyms' => 'synonyms#update'
  end

  root to: 'unbounded/browse#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
