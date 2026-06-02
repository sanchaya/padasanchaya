Rails.application.routes.draw do
	root "padas#index"
  get 'stats', to: 'stats#index'
  get 'about', to: 'padas#about'
  # resources :padas
  # resources :dictionaries
  # resources :languages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
