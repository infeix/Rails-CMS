# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :exception

  def authenticate_admin!
    unless current_user.is_admin?
      sign_out current_user

      redirect_to root_path

      return false
    end
  end

  def authenticate_agent!
    unless current_user.is_agent? || current_user.is_admin?
      sign_out current_user

      redirect_to root_path

      return false
    end
  end

  def page_not_found
    render template: 'errors/not_found_error', layout: 'layouts/application', status: 404
  end
end
