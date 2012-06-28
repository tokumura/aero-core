AeroCore::Application.routes.draw do
  resources :departments
  resources :welcome, :only => ['index']

  resources :categories do
    member do
      get :products
    end
  end

  resources :products do
    collection do
      post :find
      get :findall
      get :findall_desc_name
      get :download
      get :index_for_client
    end
    member do
      get :belong
      get :belong_order
      get :download_detail
      get :relations
      post :relations_update
    end
  end

  resources :users do
    member do
      get :make_admin
    end
    member do
      get :remove_admin
    end
  end

  #resources :relations, :only => ['edit', 'index']
  resources :relations do
    member do
      get :upanel
    end
    member do
      get :get_items
    end
  end

  devise_for :user

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
  root :to => "welcome#index"
  get 'products', :to => 'products#index', :as => :user_root
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
