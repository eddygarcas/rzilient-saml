Rails.application.routes.draw do
  devise_scope :users do
    match '/saml/:identity_provider_id/callback',
          via: [:get, :post],
          to: 'callbacks#saml',
          as: 'user_omniauth_callback'
    post '/saml/:identity_provider_id',
         to: 'callbacks#passthru',
         as: 'user_omniauth_authorize'
  end

  root to: "application#login", as: "soo_login"
  post "/sso/provider", to: "application#idp_login", as: "soo_provider"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
