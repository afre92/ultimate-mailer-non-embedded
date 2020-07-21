# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'errors#show', as: 'not_found'
  get 'templates/edit'
  patch 'templates/update'
  #submit from form in email
  get '/review-submission/:uuid', to: 'reviews#update', as: 'review_submission'
  # review extra items on order
  get '/review/:uuid/edit', to: 'reviews#edit'
  get '/review/:uuid/upload-images', to: 'reviews#images_upload'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
