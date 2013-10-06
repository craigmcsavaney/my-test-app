Myapplication::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      match 'serve/:merchant_id', to: 'api#serve', :as => :serve, format: 'json'
      match 'view/:merchant_id', to: 'api#view', :as => :view, format: 'json'
      match 'update/:merchant_id', to: 'api#update', :as => :update, format: 'json'
      match 'causes/:merchant_id', to: 'api#causes', :as => :causes, format: 'json'
      match 'sale', to: 'api#sale', :as => :sale, format: 'json'
      match 'content', to: 'api#content', :as => :content, format: 'json'
    end
  end

#  match '/api/serve/:merchant_id', to: 'api#serve', :as => :api_serve, format: 'json'
#  match '/api/view/:merchant_id', to: 'api#view', :as => :api_view, format: 'json'
  #match '/api/serve/:merchant_id', to: 'api#serve', :as => :api_serve, format: 'json'
  #match '/api/serve/:merchant_id', to: 'api#serve', :as => :api_serve, format: 'json'

  match '/merchants/new_admin',  to: 'merchants#new_admin', :as => :new_merchant_admin 
  match '/merchants/create_admin',  to: 'merchants#create_admin'
  match '/merchants/index_admin',  to: 'merchants#index_admin', :as => :merchants_admin 
  match '/merchants/:id/edit_admin',  to: 'merchants#edit_admin', :as => :edit_merchant_admin 
  match '/merchants/:id/update_admin',  to: 'merchants#update_admin'
  match '/merchants/:id/destroy_admin',  to: 'merchants#destroy_admin', :as => :destroy_merchant_admin
  match '/merchants/:id/current',  to: 'merchants#current', :as => :current_promotion
  match '/merchants/show_admin/:id',  to: 'merchants#show_admin', :as => :merchant_admin 

  match '/promotions/new_admin',  to: 'promotions#new_admin', :as => :new_promotion_admin 
  match '/promotions/create_admin',  to: 'promotions#create_admin'
  match '/promotions/index_admin',  to: 'promotions#index_admin', :as => :promotions_admin 
  match '/promotions/:id/edit_admin',  to: 'promotions#edit_admin', :as => :edit_promotion_admin 
  match '/promotions/:id/update_admin',  to: 'promotions#update_admin'
  match '/promotions/:id/destroy_admin',  to: 'promotions#destroy_admin', :as => :destroy_promotion_admin
  match '/promotions/:id/duplicate',  to: 'promotions#duplicate', :as => :duplicate_promotion
  match '/promotions/:id/duplicate_admin',  to: 'promotions#duplicate_admin', :as => :duplicate_promotion_admin
  match '/promotions/:merchant_id/current',  to: 'promotions#current', :as => :current_promotion

  match '/causes/new_admin',  to: 'causes#new_admin', :as => :new_cause_admin 
  match '/causes/create_admin',  to: 'causes#create_admin'
  match '/causes/index_admin',  to: 'causes#index_admin', :as => :causes_admin 
  match '/causes/:id/edit_admin',  to: 'causes#edit_admin', :as => :edit_cause_admin 
  match '/causes/:id/update_admin',  to: 'causes#update_admin'
  match '/causes/:id/destroy_admin',  to: 'causes#destroy_admin', :as => :destroy_cause_admin

  match '/donations/index_admin',  to: 'donations#index_admin', :as => :donations_admin 
  match '/donations/show_admin/:id',  to: 'donations#show_admin', :as => :donation_admin 

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
  
  root to: 'static_pages#home'

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/signup',  to: 'devise/registrations#new'
  #match '/new_merchant',  to: 'merchants#new'
  match '/new-merchant',  to: 'merchants#new'
  match '/create_promotion',  to: 'promotions#new'
  match '/create-promotion',  to: 'promotions#new'
  match '/user/sign_out', to: 'devise/sessions#destroy'



  devise_for :users #, :controllers => { :invitations => "invitations" }
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
