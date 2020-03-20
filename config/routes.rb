Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, except: %i[new edit], shallow: true do
    resources :answers, except: %i[show new]
  end
end
