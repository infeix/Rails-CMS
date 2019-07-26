Rails.application.routes.draw do
  resources :messages
  devise_for :users
  resources :users
  resources :templates, controller: 'templates' do
    resources :css_parts, controller: 'templates/css_parts'
    resources :html_parts, controller: 'templates/html_parts'
  end
  resources :pages, controller: 'pages'
  resources :articles, controller: 'articles'
  resources :pictures, controller: 'pictures'
  resources :videoelements, controller: 'videoelements'
  resources :textelements, controller: 'textelements'
  resources :urlelements, controller: 'urlelements'
  resources :overviews, only: [:index]
  resources :transactions
  resources :accounts
  resources :views
  resources :document_templates
  resources :invoices, controller: 'invoices' do
    resources :services, controller: 'invoices/services'
  end
  resources :contacts
  root 'pages#show', id: 'index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
