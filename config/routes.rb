Rails.application.routes.draw do
  root 'main#home'
  get '/cookie_hack' => 'main#cookie_hack'

  post '/pablo' => 'pablo#pablo'
  post '/hook' => 'pablo#pablo'
  get '/pablo_test' => 'pablo#pablo'
  get '/boba' => 'pablo#boba'
  get '/pablo/admin'=>'pablo#admin'
  post '/pablo/send/:id' => 'pablo#admin_send'
  get '/hook' => 'pablo#hook'
  get '/pablo' => 'pablo#hook'
  get '/pablo/broadcast' => 'pablo#admin_broadcast'
  post '/pablo/broadcast' => 'pablo#broadcast'

  # authentication 
  get "/auth/google_oauth2/callback", to: "auth#google_callback"
  get '/auth/email', to:'auth#email'
  get "/auth/logout", to: "auth#logout"
  get '/unauthorized', to: 'application#unauthorized'

  # get and set member data
  get 'me' => 'members#me'
  get 'members' => 'members#index'
  post 'me/update' => 'members#update'
  post 'me/update_commitments' => 'members#update_commitments'

  # pbl links
  get ':key/go' => 'go#redirect'
  get 'go' => 'go#index'
  get 'go/menu' => 'go#index'
  get 'go/ajax_scroll/:page' => 'go#ajax_scroll'
  get 'go/show/:id' => 'go#show'
  get 'go/search' => 'go#search'
  get 'go/add' => 'go#add'
  post 'go/update' => 'go#update'
  post 'go/destroy/:id' => 'go#destroy'
  get 'go/lookup' => 'go#lookup'
  
  # batch editing pbl links
  post 'go/batch_update_groups' => 'go#batch_update_groups'
  post 'go/add_checked_id' => 'go#add_checked_id'
  post 'go/remove_checked_id' => 'go#remove_checked_id'
  get 'go/get_checked_ids' => 'go#get_checked_ids'
  get 'go/ajax_get_checked' => 'go#ajax_get_checked'
  get 'go/deselect_links' => 'go#deselect_links'
  get 'go/delete_checked' => 'go#delete_checked'

  # go link trash
  get 'go/trash' => 'go#trash'
  post 'go/restore/:id' => 'go#restore'
  post 'go/destroy_copy/:id' => 'go#destroy_copy'

  # monitoring PBL Links
  # TODO

  #blog
  get 'blog' => 'blog#index'
  get 'blog/ajax_scroll/:page' => 'blog#ajax_scroll'
  get 'blog/show/:id' => 'blog#show'
  get 'blog/edit' => 'blog#edit'
  get 'blog/email/:id' => 'blog#email'
  get 'blog/post/:id' => 'blog#post'
  post 'blog/save' => 'blog#save'
  get 'blog/destroy/:id' => 'blog#destroy'
  post 'blog/send_email/:id' => 'blog#send_email'
  get 'blog/comments/:id' => 'blog#comments'
  post 'blog/post_comment/:id' => 'blog#post_comment'
  post 'blog/delete_comment/:id' => 'blog#delete_comment'
  get 'blog/push_post/:id' => 'blog#push_post'

  #tabling
  get 'tabling' => 'tabling#index'
  post 'tabling/switch' => 'tabling#switch'
  get 'tabling/confirm_switch/:id' => 'tabling#confirm_switch'
  # get 'tabling/generate' => 'tabling#generate'
  get 'tabling/schedules' => 'tabling#schedules'
  post 'tabling/admin_switch' => 'tabling#admin_switch'
  get 'tabling/slots_available' => 'tabling#slots_available'
  get 'tabling/chair_tabling' => 'tabling#chair_tabling', as: 'chair_tabling'
  
  # registering for push notifications
  get 'push' => 'push#index'
  get 'push/register'  => 'push#register'
  get 'push/new' => 'push#new'
  post 'push/create' => 'push#create'


  # points and events
  get 'points' => 'points#attendance'
  get 'points/scoreboard' => 'points#scoreboard'
  get 'points/distribution' => 'points#distribution'
  get 'points/attendance' => 'points#attendance'
  post 'points/mark_attendance' => 'points#mark_attendance'
  get 'pull_events' => 'points#pull_events'


  # groups
  get 'groups' => 'groups#index'
  post 'groups/create' => 'groups#create'
  get 'groups/destroy/:id' => 'groups#destroy'
  get 'groups/edit/:id'=>'groups#edit'
  post 'groups/update/:id'=>'groups#update'
  get 'groups/new' => 'groups#new'

  get 'clicks' => 'clicks#index'
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
