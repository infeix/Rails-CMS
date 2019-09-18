# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def authenticate_admin!
    authenticate_user!
    redirect_to user_session_path unless current_user.is_admin?
  end

  def index
    authenticate_admin!
    @pages = Page.all
  end

  def show
    if @page.present? && current_user.blank?
      view = View.new
      view.page = @page
      view.ref = request.referrer.presence
      view.save!
    end
    render layout: "custompage"
  end

  def new
    authenticate_admin!
    @page = Page.new
  end

  def edit
    authenticate_admin!
  end

  def create
    authenticate_admin!
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to overviews_path, notice: 'Page was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authenticate_admin!
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to overviews_path, notice: 'Page was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authenticate_admin!
    @page.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Page was successfully destroyed.' }
    end
  end

  private

  def set_page
    @page = Page.find_by(path: params[:id])
  end

  def page_params
    params.require(:page).permit(
      :title,
      :text,
      :path,
      :template_element_id,
      :code,
      :edit_filter,
      :content_part_ids => []).tap do |param|
      if param[:content_part_ids].blank?
        param[:content_part_ids] = []
      end
    end
  end
end
