Rails.application.routes.draw do
  scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
    resources :likes, only: %i[index create destroy]
    resources :authors, only: %i[index show]
    resources :categories, only: :index
    resources :recipes, only: %i[index show]
    mount VandalUi::Engine, at: '/vandal'
  end
end
