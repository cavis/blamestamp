Dummy::Application.routes.draw do

  root :to => "home#index"
  devise_for :users
  resources :projects do
    resources :alligators
    resources :flags
  end
  resources :alligators do
    resources :flags
  end

end
