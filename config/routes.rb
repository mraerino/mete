Mete::Application.routes.draw do
  resources :drinks
  resources :barcodes

  get 'audits' => 'audits#index'

  resources :users do
    member do
      get :deposit
      get :payment
      get :buy
      post :buy_barcode
    end
    collection do
      get 'stats'
    end
  end


  scope :api do
    constraints lambda {|req| req.format == :json} do
      # Just to have it we add v1 here as well
      scope :v1 do
        resources :drinks
        resources :barcodes

        get 'audits' => 'audits#index'

        resources :users do
          member do
            get :deposit
            get :payment
            get :buy
            post :buy_barcode
          end
          collection do
            get 'stats'
          end
        end
      end
      scope :v2 do
        defaults api: 'v2' do
          get 'info' => 'application#info'
          resources :application
          resources :drinks, path: 'products'
          resources :barcodes
          get 'audits' => 'audits#index'
          resources :users do
            member do
              post :deposit
              post :payment, path: 'pay'
              post :buy, path: 'product'
              post :buy_barcode
            end
            collection do
              get :stats
            end
          end
        end
      end
    end
  end
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
  # root :to => 'welcome#index'
  root :to => 'users#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
