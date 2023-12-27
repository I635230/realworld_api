Rails.application.routes.draw do
  scope :api do
    post "/users/login", to: "authentications#create"
    get "/user", to: "current_users#show"
    resources :users, only: %i[create]
    resources :articles, param: :slug, only: %i[show create update destroy]
    resources :tags, only: %i[index]
  end
end
