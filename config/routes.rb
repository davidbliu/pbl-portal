Rails.application.routes.draw do
  get 'test' => 'test#test'
  root 'main#home'


  # authentication 
  get "/auth/google_oauth2/callback", to: "auth#google_callback"
  get '/auth/email', to:'auth#email'
  get "/auth/logout", to: "auth#logout"

  # get and set member data
  get 'me' => 'members#me'
  get 'officer' => 'members#officer'
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
  get 'go/engagement' => 'go#engagement'
  get 'go/admin' => 'go#admin'
  get 'go/three_days' => 'go#three_days'

  #blog
  get 'blog' => 'blog#index'
  get 'blog/edit' => 'blog#edit'
  get 'blog/email/:id' => 'blog#email'
  get 'blog/post/:id' => 'blog#post'
  post 'blog/save' => 'blog#save'
  post 'blog/destroy/:id' => 'blog#destroy'
  post 'blog/send_email/:id' => 'blog#send_email'
  post 'blog/post_comment/:id' => 'blog#post_comment'
  get 'blog/push_post/:id' => 'blog#push_post'

  #tabling
  get 'tabling' => 'tabling#index'
  post 'tabling/switch' => 'tabling#switch'
  get 'tabling/confirm_switch/:id' => 'tabling#confirm_switch'
  get 'tabling/generate' => 'tabling#generate'
  get 'tabling/schedules' => 'tabling#schedules'
  post 'tabling/admin_switch' => 'tabling#admin_switch'
  get 'tabling/slots_available' => 'tabling#slots_available'
  
  # push notifications
  get 'push' => 'push#index'
  get 'push/register'  => 'push#register'
  get 'push/new' => 'push#new'
  post 'push/create' => 'push#create'

  

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

  #reminders
  # get 'reminders' => 'reminder#index'
  # post 'reminders/delete' => 'reminder#delete'
  # get 'reminders/redirect/:id' => 'reminder#redirect'
  # get 'reminders/new' => 'reminder#new'
  # get 'reminders/admin' => 'reminder#admin'
  # get 'reminders/destroy_all' => 'reminder#destroy_all'
  post 'reminders/create' => 'reminder#create'
  # post 'reminders/destroy_id' => 'reminder#destroy_id'
  

  #iter2 of reminders
  get 'reminders' => 'reminder#index'
  get 'reminders/new2' => 'reminder#new2'
  get 'reminders/admin2' => 'reminder#admin2'
  post 'reminders/set_response' => 'reminder#set_response'
  get 'reminders/reminder/:id' => 'reminder#view_reminder'
  get 'reminders/destroy/:id' => 'reminder#destroy_id'
  get 'reminders/refresh' => 'reminder#refresh'
  get 'reminders/refresh_response/:id' => 'reminder#refresh_response'
  get 'reminders/admin3' => 'reminder#admin3'
  get 'reminders/export_csv/:id' => 'reminder#export_csv'

  get 'courseware' => 'courseware#index'

  # points and events
  get 'points' => 'points#index'
  get 'points/scoreboard' => 'points#scoreboard'
  get 'points/distribution' => 'points#distribution'
  get 'points/attendance' => 'points#attendance'
  post 'points/mark_attendance' => 'points#mark_attendance'

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
