Rails.application.routes.draw do
  resources :messages
  devise_for :users
  resources :users
  resources :template_elements, controller: 'template_elements' do
    resources :css_parts, controller: 'template_elements/css_parts'
    resources :html_parts, controller: 'template_elements/html_parts'
  end
  resources :pages, controller: 'pages'
  resources :articles, controller: 'articles'
  resources :content_parts, controller: 'content_parts'
  resources :pictures, controller: 'pictures'
  resources :videoelements, controller: 'videoelements'
  resources :textelements, controller: 'textelements'
  resources :urlelements, controller: 'urlelements'
  resources :pdf_files, controller: 'pdf_files'
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
