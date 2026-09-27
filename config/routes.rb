Rails.application.routes.draw do
  namespace :admin do
    resource :session
    resources :passwords, param: :token

    resource :dashboard, only: [ :show ]
    resources :reports, only: [ :index ] do
      collection do
        get :students
        get :themes
      end
    end
    resources :admins, except: [ :show ]
    resources :students, only: [ :index ] do
      member do
        patch :block
        patch :unblock
      end
    end

    resources :levels do
      resources :themes, shallow: true do
        resources :questions, shallow: true
      end
    end
    root to: "dashboards#show"
  end

  # Autenticação e rotas de aluno
  get "/cadastrar", to: "users/registrations#new"
  post "/cadastrar", to: "users/registrations#create"

  get "/entrar", to: "users/sessions#new"
  post "/entrar", to: "users/sessions#create"
  delete "/sair", to: "users/sessions#destroy"

  get "/jornada", to: "dashboard#index"
  get "/ranking", to: "rankings#index"

  root to: redirect("/jornada")
  namespace :play do
    resources :themes, only: [] do
      post :start, on: :member
      get :finish, on: :member
    end
    resources :theme_attempts, only: [] do
      resource :question, only: [ :show ] do
        post :reveal
        post :submit
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
