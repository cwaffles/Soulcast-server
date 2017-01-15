Rails.application.routes.draw do

  resources :improves
  resources :blocks
  resources :histories
  resources :souls
  resources :devices

  # actual stuff
  root  'website#index' # show the homepage in production mode
  get   'nearby',   to: 'devices#nearby' # returns how many devices nearby
  get   'device_history/:id',  to: 'histories#device_history'

  # test stuff
  get   'test',         to: 'test#index'
  post  'test',         to: 'test#sendToEveryone'
  post  'echo',         to: 'echo#reply'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
