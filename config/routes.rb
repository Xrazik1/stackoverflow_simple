Rails.application.routes.draw do
  root 'questions#index'

  resources :questions, except: :new, shallow: true do
    resources :answers, only: %i[create destroy update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
