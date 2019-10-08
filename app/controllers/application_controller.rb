# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :exception


  def authenticate_admin!
    if current_user.is_admin?
      redirect_to user_session_path unless current_user.is_admin?
      true
    else
      false
    end
  end

  def authenticate_agent!
    if current_user.is_agent? || current_user.is_admin?
      redirect_to user_session_path unless current_user.is_agent? || current_user.is_admin?
      true
    else
      false
    end
  end
end
