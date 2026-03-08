Rails.application.routes.draw do
  get "employees/index"
  root "employees#index"
  resources :employees do
    member do
      get :confirm_destroy
    end
  end
  resources :attendances do
    member do
      get :checkout
    end
    collection do
      get :checkin
    end
  end
  resources :pins, only: [] do
    collection do
      get  :verify
      post :check
    end
  end
end
