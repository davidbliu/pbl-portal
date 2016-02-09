Rails.application.routes.draw do
  get 'test' => 'test#test'
  root 'main#home'


  # authentication 
  get "/auth/google_oauth2/callback", to: "auth#google_callback"
  get '/auth/email', to:'auth#email'
  get "/auth/logout", to: "auth#logout"

  # get and set member data
  get 'me' => 'members#me'
  get 'members' => 'members#index'
  post 'me/update' => 'members#update'
  post 'me/update_commitments' => 'members#update_commitments'

  # pbl links
  get ':key/go' => 'go#redirect'
  get 'go' => 'go#index'
  get 'go/menu' => 'go#index'
  get 'go/search' => 'go#search'
  get 'go/lookup' => 'go#lookup'
  get 'go/insights/:id' => 'go#insights'
  get 'go/recent' => 'go#recent'
  
  get 'go/add' => 'go#add'
  post 'go/create' => 'go#create'
  post 'go/update' => 'go#update'
  post 'go/destroy' => 'go#destroy'
  get 'go/insights/:id' => 'go#insights'

  #blog
  get 'blog' => 'blog#index'
  get 'blog/edit' => 'blog#edit'
  get 'blog/email/:id' => 'blog#email'
  get 'blog/post/:id' => 'blog#post'
  post 'blog/save' => 'blog#save'
  post 'blog/destroy/:id' => 'blog#destroy'
  post 'blog/send_email/:id' => 'blog#send_email'

  #tabling
  get 'tabling' => 'tabling#index'
  post 'tabling/switch' => 'tabling#switch'
  get 'tabling/confirm_switch/:id' => 'tabling#confirm_switch'
  get 'tabling/generate' => 'tabling#generate'
  get 'tabling/schedules' => 'tabling#schedules'
  post 'tabling/admin_switch' => 'tabling#admin_switch'
  # push notifications
  get 'push' => 'push#index'
  get 'push/register'  => 'push#register'

  # points
  get 'points' => 'points#index'

  # feed
  get 'feed' => 'feed#feed'
  get 'feed/read' => 'feed#read'
  get 'feed/view' => 'feed#view_feed'
  post 'feed/create' => 'feed#create'
  post 'feed/destroy' => 'feed#destroy'
  get 'feed/push/:id' => 'feed#push'
  get 'feed/details/:id' => 'feed#details'
  post 'feed/mark_read' => 'feed#mark_read'
  post 'feed/remove' => 'feed#remove'
  get 'feed/view_push/:id' => 'feed#view_push'

  # precompute stuff
  get 'c/trending_links' => 'compute#trending_links'

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
