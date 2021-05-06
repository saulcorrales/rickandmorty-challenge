# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'health/', to: 'health#check'
      get 'char_counter/', to: 'char_counter#index'
      get 'episode_location/', to: 'episode_location#index'
    end
  end
end
