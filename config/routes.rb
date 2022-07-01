Rails.application.routes.draw do
  resources :geo_datum, only: :create do
    collection do
      delete '', action: :destroy
      get '', action: :show
    end
  end
end
