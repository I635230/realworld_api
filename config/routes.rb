Rails.application.routes.draw do
  scope :api do
    post "/users/login", to: "authentications#create", as: "login"
    get "/user", to: "users#show"
    put "/user", to: "users#update"
    resources :users, only: %i[create]
    resources :articles, param: :slug, only: %i[index show create update destroy]
    resources :tags, only: %i[index]
    resources :profiles, param: :username, only: %i[show] do
      member do
        post :follow, to: 'profiles#follow'
        delete :follow, to: 'profiles#unfollow'
      end
    end
  end
end
