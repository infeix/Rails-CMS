# frozen_string_literal: true

class TextelementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_textelement, only: [:show, :edit, :update, :destroy]

  def index
    @textelements = Textelement.all
  end

  def show
  end

  def new
    @textelement = Textelement.new
    find_page
  end

  def edit
  end

  def create
    @textelement = Textelement.new(textelement_params)

    respond_to do |format|
      if @textelement.save
        format.html { redirect_to overviews_path, notice: 'Textelement was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @textelement.update(textelement_params)
        format.html { redirect_to overviews_path, notice: 'Textelement was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @textelement.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Textelement was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @textelement.page = @page
    end
  end

  def set_textelement
    @textelement = Textelement.find(params[:id])
  end

  def textelement_params
    params.require(:textelement).permit(:title, :text, :position, :page_id, :template_element_id, :image, :remove_image, :video, :remove_video)
  end
end
