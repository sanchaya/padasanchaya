Rails.application.routes.draw do
	root "padas#index"
  get 'stats', to: 'stats#index'
  get 'about', to: 'padas#about'
  get 'help', to: 'padas#help'
  get 'contribute', to: 'jana_sanchaya_entries#new'
  get 'community', to: 'jana_sanchaya_entries#index'
  get 'robots', to: 'seo#robots', defaults: { format: :txt }
  get 'sitemap', to: 'seo#sitemap', defaults: { format: :xml }

  resources :jana_sanchaya_entries, only: [:new, :create, :index] do
    member do
      post 'vote'
      delete 'vote', to: 'jana_sanchaya_entries#remove_vote'
    end
  end

  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    get 'dashboard', to: 'dashboard#index'
    get 'settings', to: 'dashboard#settings', as: :settings
    post 'settings', to: 'dashboard#update_settings'
    post 'settings/password', to: 'dashboard#update_password', as: :update_password

    resources :community_entries, except: [:new, :create]

    resources :dictionaries do
      member do
        get 'entries/:id/edit_entry', to: 'dictionaries#edit_entry', as: :edit_entry
        patch 'entries/:id/update_entry', to: 'dictionaries#update_entry', as: :update_entry
      end
    end
  end

  # resources :padas
  # resources :dictionaries
  # resources :languages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
