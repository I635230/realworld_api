Rails.application.routes.draw do
  scope :api do
    post "/users/login", to: "authentications#create"
    resources :users, only: %i[create]
    resources :articles, param: :slug, only: %i[show create update]
  end
end
