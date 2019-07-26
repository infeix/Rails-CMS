# frozen_string_literal: true

class VideoelementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_videoelement, only: [:show, :edit, :update, :destroy]

  def index
    @videoelements = Picture.all
  end

  def show
  end

  def new
    @videoelement = Picture.new
    find_page
  end

  def edit
  end

  def create
    @videoelement = Picture.new(videoelement_params)

    respond_to do |format|
      if @videoelement.save
        format.html { redirect_to overviews_path, notice: 'Picture was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @videoelement.update(videoelement_params)
        format.html { redirect_to overviews_path, notice: 'Picture was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @videoelement.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Picture was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @videoelement.page = @page
    end
  end

  def set_videoelement
    @videoelement = Picture.find(params[:id])
  end

  def videoelement_params
    params.require(:videoelement).permit(:title, :text, :position, :page_id, :template_id, :image, :remove_image, :video, :remove_video)
  end
end
