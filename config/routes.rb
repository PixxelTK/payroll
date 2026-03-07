Rails.application.routes.draw do
  get "employees/index"
  root "employees#index"
  resources :employees
  resources :attendances
  resources :pins, only: [] do
    collection do
      get  :verify
      post :check
    end
  end
end
