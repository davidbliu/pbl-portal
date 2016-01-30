Rails.application.routes.draw do
  get 'test' => 'test#test'
  root 'main#home'


  # authentication 
  get "/auth/google_oauth2/callback", to: "auth#google_callback"
  get '/auth/email', to:'auth#email'

  # get and set member data
  get 'me' => 'members#me'
  get 'members' => 'members#index'
  post 'me/update' => 'members#update'
  post 'me/update_commitments' => 'members#update_commitments'

  # pbl links
  get ':key/go' => 'go#redirect'
  get 'go/menu' => 'go#index'
  get 'go/search' => 'go#search'
  get 'go/insights/:id' => 'go#insights'
  
  get 'go/add' => 'go#add'
  post 'go/create' => 'go#create'
  post 'go/update' => 'go#update'
  post 'go/destroy' => 'go#destroy'

  #blog
  get 'blog' => 'blog#index'

  #tabling
  get 'tabling' => 'tabling#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
