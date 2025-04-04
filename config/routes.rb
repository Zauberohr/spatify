Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  # Optional: falls du eigene User-Erstellung brauchst
  resources :users, only: [:new, :create]

  # Healthcheck für Uptime-Monitoring
  get "up" => "rails/health#show", as: :rails_health_check

  # Spatis mit allen Standard-Aktionen
  resources :spatis do
    resources :stories, path: "story", only: [:new, :create]
  end

  # Einzelne Routen für Story-Update und -Löschen
  resources :stories, path: "story", only: [:update, :edit, :destroy]
end
