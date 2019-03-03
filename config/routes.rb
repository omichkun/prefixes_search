Rails.application.routes.draw do
  root to: 'main#main'
  post 'search' => 'main#search'
end
