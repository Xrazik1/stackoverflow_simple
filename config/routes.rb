Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, except: %i[new edit], shallow: true do
    resources :answers, only: %i[create destroy]
  end

  patch '/answers/:id/set_best_answer', to: 'answers#set_best_answer', as: 'set_best_answer'
end
