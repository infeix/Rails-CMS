# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :copy, :update, :destroy]
  before_action :authenticate_agent!, only: [:new, :edit, :create, :copy, :update, :destroy]

  before_action :set_page, only: [:show, :filter, :edit, :update, :destroy, :copy]


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

  def copy
    authenticate_admin!

    new_page = @page.make_a_copy(page_params)
    @page = new_page
    redirect_to overviews_path, notice: 'Page was successfully created.'
  end

  def filter
    authenticate_agent!
    if @page.present?
      @page.edit_filter = true
      if @page.save
        redirect_to overviews_path
      else
        redirect_to overviews_path, alert: 'Error.'
      end
    end
  end

  def update
    authenticate_admin!
    if @page.update(page_params)
      redirect_to overviews_path, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authenticate_admin!

    @page.destroy
    ContentPart.all.each do |part|
      if part.pages.count == 0
        part.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Page was successfully destroyed.' }
    end
  end

  private

  def set_page
    @page = Page.find_by(path: params[:id])
  end

  def page_params
    unless params[:action].eql?('copy')
      params.require(:page).permit(
        :title,
        :text,
        :path,
        :template_element_id,
        :code,
        :edit_filter)
    else
      params.permit(:page).permit(
        :title,
        :text,
        :path,
        :template_element_id,
        :code,
        :edit_filter)
    end
  end
end
