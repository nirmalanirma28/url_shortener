Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :urls, only: %i[create show index]
  post '/generate_token', to: 'urls#generate_token'
  get '/shortened_url', to: 'urls#redirect'
end
