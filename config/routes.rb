ActionController::Routing::Routes.draw do |map|
  map.resources :updates
  
  map.home '', :controller => "updates"
  
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
