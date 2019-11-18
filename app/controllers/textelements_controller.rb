# frozen_string_literal: true

class TextelementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

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

    if @textelement.save
      redirect_to overviews_path, notice: 'Textelement was successfully created.'
    else
      render :new
    end
  end

  def copy
    @textelement = Textelement.new(textelement_params)

    if @textelement.save
      redirect_to overviews_path, notice: 'Textelement was successfully created.'
    else
      render :new
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
      @textelement.pages << @page
    end
  end

  def set_textelement
    @textelement = Textelement.find(params[:id])
  end

  def textelement_params
    params.require(:textelement).permit(:title,
      :text,
      :position,
      :index,
      :template_element_id,
      :template_element_id,
      :image,
      :remove_image,
      :video,
      :data_text,
      :remove_video,
      :page_ids => []).tap do |param|
        if param[:template_element_id].blank? || param[:template_element_id].eql?("nil")
          param[:template_element_id] = nil
        end
      end
  end
end
