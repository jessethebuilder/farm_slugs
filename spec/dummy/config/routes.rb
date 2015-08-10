Rails.application.routes.draw do

  resources :farm_slug_request_objects
  mount FarmSlugs::Engine => "/farm_slugs"
end
