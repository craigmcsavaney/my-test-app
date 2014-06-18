Myapplication::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'serve/:merchant_id', to: 'api#serve', :as => :serve, format: 'json'
      get 'view/:merchant_id', to: 'api#view', :as => :view, format: 'json'
      get 'update/:merchant_id', to: 'api#update', :as => :update, format: 'json'
      get 'causes/:merchant_id', to: 'api#causes', :as => :causes, format: 'json'
      get 'events/:merchant_id', to: 'api#events', :as => :events, format: 'json'
      get 'sale', to: 'api#sale', :as => :sale, format: 'json'
      get 'content', to: 'api#content', :as => :content, format: 'json'
    end
  end

#  match '/api/serve/:merchant_id', to: 'api#serve', :as => :api_serve, format: 'json'
#  match '/api/view/:merchant_id', to: 'api#view', :as => :api_view, format: 'json'
  #match '/api/serve/:merchant_id', to: 'api#serve', :as => :api_serve, format: 'json'
  #match '/api/serve/:merchant_id', to: 'api#serve', :as => :api_serve, format: 'json'

  get '/merchants/new_admin',  to: 'merchants#new_admin', :as => :new_merchant_admin
  post '/merchants/create_admin',  to: 'merchants#create_admin'
  get '/merchants/index_admin',  to: 'merchants#index_admin', :as => :merchants_admin
  get '/merchants/:id/edit_admin',  to: 'merchants#edit_admin', :as => :edit_merchant_admin
  patch '/merchants/:id/update_admin',  to: 'merchants#update_admin'
  delete '/merchants/:id/destroy_admin',  to: 'merchants#destroy_admin', :as => :destroy_merchant_admin
  get '/merchants/:id/current',  to: 'merchants#current', :as => :current_merchant
  get '/merchants/show_admin/:id',  to: 'merchants#show_admin', :as => :merchant_admin

  get '/promotions/new_admin',  to: 'promotions#new_admin', :as => :new_promotion_admin
  post '/promotions/create_admin',  to: 'promotions#create_admin'
  get '/promotions/index_admin',  to: 'promotions#index_admin', :as => :promotions_admin
  get '/promotions/:id/edit_admin',  to: 'promotions#edit_admin', :as => :edit_promotion_admin 
  patch '/promotions/:id/update_admin',  to: 'promotions#update_admin'
  delete '/promotions/:id/destroy_admin',  to: 'promotions#destroy_admin', :as => :destroy_promotion_admin
  get '/promotions/:id/duplicate',  to: 'promotions#duplicate', :as => :duplicate_promotion
  get '/promotions/:id/duplicate_admin',  to: 'promotions#duplicate_admin', :as => :duplicate_promotion_admin
  get '/promotions/:merchant_id/current',  to: 'promotions#current', :as => :current_promotion

  get '/causes/new_admin',  to: 'causes#new_admin', :as => :new_cause_admin
  post '/causes/create_admin',  to: 'causes#create_admin'
  get '/causes/index_admin',  to: 'causes#index_admin', :as => :causes_admin
  get '/causes/:id/edit_admin',  to: 'causes#edit_admin', :as => :edit_cause_admin
  patch '/causes/:id/update_admin',  to: 'causes#update_admin'
  delete '/causes/:id/destroy_admin',  to: 'causes#destroy_admin', :as => :destroy_cause_admin

  get '/singles/new_admin',  to: 'singles#new_admin', :as => :new_single_admin
  post '/singles/create_admin',  to: 'singles#create_admin'
  get '/singles/index_admin',  to: 'singles#index_admin', :as => :singles_admin
  get '/singles/:id/edit_admin',  to: 'singles#edit_admin', :as => :edit_single_admin
  patch '/singles/:id/update_admin',  to: 'singles#update_admin'
  delete '/singles/:id/destroy_admin',  to: 'singles#destroy_admin', :as => :destroy_single_admin

  get '/donations/index_admin',  to: 'donations#index_admin', :as => :donations_admin
  get '/donations/show_admin/:id',  to: 'donations#show_admin', :as => :donation_admin

  resources :roles
  resources :merchants
  resources :promotions
  resources :causes
  resources :channels
  resources :types
  resources :settings
  resources :serves
  resources :shares
  resources :sales
  resources :donations
  resources :button_types
  resources :buttons
  resources :events
  resources :groups
  resources :singles
  resources :contact_messages, only: :create
  
  root to: 'static_pages#landing'

  get '/home',    to: 'static_pages#home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup',  to: 'devise/registrations#new'
  get '/facebook-success', to: 'static_pages#facebook_success'
  get '/create_promotion',  to: 'promotions#new'
  delete '/user/sign_out', to: 'devise/sessions#destroy'


  devise_for :users, :controllers => { :passwords => "passwords" }
  resources :users, only: [:edit, :update, :index]


  # get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
