# frozen_string_literal: true

class VideoelementsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_agent!

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
      @videoelement.pages << @page
    end
  end

  def set_videoelement
    @videoelement = Picture.find(params[:id])
  end

  def videoelement_params
    params.require(:videoelement).permit(
      :title,
      :text,
      :position,
      :template_element_id,
      :image,
      :remove_image,
      :video,
      :data_text,
      :remove_video,
      :page_ids => []).tap do |param|
        if param[:page_ids].blank?
          param[:page_ids] = []
        end
        if param[:template_element_id].nil?
          param.delete(:template_element_id)
        end
      end
  end
end
