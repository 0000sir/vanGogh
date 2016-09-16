Rails.application.routes.draw do
  post 'artworks/callback'=>'artworks#callback'

  resources :styles
  resource :wechat, only: [:show, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
