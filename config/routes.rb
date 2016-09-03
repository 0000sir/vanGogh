Rails.application.routes.draw do
  resource :wechat, only: [:show, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
