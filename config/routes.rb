Rails.application.routes.draw do
  namespace :admin do
    resource :session
    resources :passwords, param: :token
    resources :levels
    root to: "levels#index"
  end
  root to: redirect("/admin/session/new")
  get "up" => "rails/health#show", as: :rails_health_check
end
