# frozen_string_literal: true

class ViewsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_agent!

  # GET /views
  def index
    authenticate_admin!
    @views = View.all.order('created_at desc')
  end
end
