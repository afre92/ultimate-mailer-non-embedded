# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'errors#show', as: 'not_found'
  get 'templates/edit'
  patch 'templates/update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
