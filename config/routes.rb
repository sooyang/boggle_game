Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'home' => 'home#index'
  post 'select' => 'game#select'
  post 'add' => 'game#add'
  get 'start' => 'game#start'
end
