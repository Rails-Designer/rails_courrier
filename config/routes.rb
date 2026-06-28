# frozen_string_literal: true

Courrier::Engine.routes.draw do
  resources :inbox, only: %w[show]
  resource :cleanup, only: %w[create], controller: "inbox"

  resources :previews, only: %w[index show]

  root "inbox#index"
end
