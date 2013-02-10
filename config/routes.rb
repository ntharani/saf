Saf::Application.routes.draw do
  
  resources :users
  resources :sessions,  only: [:new, :create, :destroy]
  resources :osessions, only: [:new, :create, :destroy]
  
  resources :authors, except: [:index] do
    member do
      get   :following
      get   :followed
      post  :follow
      post  :start_follow
    end
  end

  resources :opusses do

    resources :comments

    member  do
      post  :like
      get   :authorfeed
      post  :repost
    end
  end


  root                            to: 'static_pages#home'
  #match '/signin',               to: 'sessions#new'
  #match '/signout',              to: 'sessions#destroy', via: :delete
  #match '/signup',               to: 'users#new'
  match '/signup',                to: 'authors#new'
  match '/help',                  to: 'static_pages#help'
  match '/about',                 to: 'static_pages#about'
  match '/contact',               to: 'static_pages#contact'
  match '/ologin',                to: 'osessions#new'
  match '/osignout',              to: 'osessions#destroy', via: :delete
  match '/top',                   to: 'opusses#indextop'
  match '/all',                   to: 'opusses#all_opusses'
  match '/search',                to: 'opusses#search'
  match '/start',                 to: 'authors#start'
  match 'auth/:service',          to: 'auth#service'
  match 'auth/:service/callback', to: 'auth#callback'
  match 'logout',                 to: 'auth#logout'



# Static Pages Controller

# HTTP Request |      URI      | Named Route      |    Action    |  Purpose
# ------------ | ------------- | ---------------- | ------------ | ----------
# GET          | /             | root_path        |              |
# GET          | /about        | about_path       | 
# GET          | /contact      | contact_path     | 
# GET          | /help         | help_path        | 

# Users Controller [REST]

# HTTP Request |      URI      | Named Route      |    Action    |  Purpose
# ------------ | ------------- | ---------------- | ------------ | ----------
# GET          | /users        | users_path       | index        | List all users
# GET          | /users/id     | user_path(user)  | show         | Show a user
# GET          | /users/new    | signup_path      | new          | Signup Form (Also user_new_path)
# POST         | /users        | users_path       | create       | Create a user object
# GET          | /users/id/edit| user_path(user)  | edit         | Show the edit user form
# PUT          | /users/id     | user_path(user)  | update       | Update the user object (Also edit_user_path)
# DELETE       | /users/id     | user_path(user)  | destroy      | Delete the user object


# Sessions Controller [REST]

# HTTP Request |      URI      | Named Route      |    Action    |  Purpose
# ------------ | ------------- | ---------------  | ------------ | ----------
# GET          | /signin       | signin_path      | new          | Form for session (signin)
# POST         | /sessions     | sessions_path    | create       | create session
# DELETE       | /signout      | signout_path     | destroy      | delete session (signout)


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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
