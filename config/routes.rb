Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'

  resources :books do
    resources :comments, only: %i(index show)
  end

  scope module: :books do
    resources :books do
      resources :comments, only: %i(edit create update destroy)
    end
  end

  resources :reports do
    resources :comments, only: %i(index show)
  end

  scope module: :reports do
    resources :reports do
      resources :comments, only: %i(edit create update destroy)
    end
  end  

  resources :users, only: %i(index show)

  get '*path', to: 'application#record_not_found'
end
