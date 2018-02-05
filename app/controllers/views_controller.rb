# frozen_string_literal: true

class ViewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  # GET /views
  def index
    authenticate_admin!
    @views = View.all.order('created_at desc')
  end
end
