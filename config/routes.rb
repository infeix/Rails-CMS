Rails.application.routes.draw do
  resources :messages
  devise_for :users
  resources :users
  resources :templates, controller: 'templates' do
    resources :css_parts, controller: 'templates/css_parts'
    resources :html_parts, controller: 'templates/html_parts'
  end
  resources :pages, controller: 'pages' do
    resources :articles, controller: 'pages/articles'
  end
  resources :overviews, only: [:index]

  resources :transactions
  resources :accounts
  resources :document_templates
  resources :invoices, controller: 'invoices' do
    resources :services, controller: 'invoices/services'
  end
  resources :contacts

  root 'pages#show', id: 'index'
end
