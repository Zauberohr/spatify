Rails.application.routes.draw do
  # Authentifizierung mit Devise
  devise_for :users

  # Startseite der App
  root to: "pages#home"

  # Optional: falls du neue Nutzer manuell anlegen willst
  resources :users, only: [:new, :create]

  # Healthcheck-Endpunkt für Monitoring (z. B. UptimeRobot)
  get "up" => "rails/health#show", as: :rails_health_check

  # Spätis mit allen Standardaktionen (index, show, new, create, edit, update, destroy)
  # + verschachtelte Story-Erstellung (pro Späti)
  resources :spatis do
    resources :stories, path: "story", only: [:new, :create]
  end

  # Story-Bearbeitung & -Löschung unabhängig vom Späti
  resources :stories, path: "story", only: [:edit, :update, :destroy]
end
