# frozen_string_literal: true

class PicturesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  def index
    @pictures = Picture.all
  end

  def show
  end

  def new
    @picture = Picture.new
    find_page
  end

  def edit
  end

  def create
    @picture = Picture.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to overviews_path, notice: 'Picture was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to overviews_path, notice: 'Picture was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Picture was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @picture.pages << @page
    end
  end

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.require(:picture).permit(
      :title,
      :text,
      :position,
      :template_element_id,
      :image,
      :data_text,
      :remove_image,
      :video,
      :remove_video,
      :page_ids => []).tap do |param|
        if param[:page_ids].blank?
          param[:page_ids] = []
        end
      end
  end
end
