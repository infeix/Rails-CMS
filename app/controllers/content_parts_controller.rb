# frozen_string_literal: true

class ContentPartsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  before_action :set_content_part, only: [:show, :edit, :update, :destroy]

  def index
    @content_parts = ContentPart.all
  end

  def show
  end

  def new
    @content_part = ContentPart.new
    find_page
  end

  def edit
  end

  def create
    type = content_part_params[:type]
    @content_part = ContentPart.new(content_part_params.except(:type))
    @content_part.type = type

    if @content_part.save
      redirect_to overviews_path, notice: 'ContentPart was successfully created.'
    else
      redirect_to overviews_path, alert: 'ContentPart was not created.'
    end
  end

  def copy
    @content_part = ContentPart.new(content_part_params)

    if @content_part.save
      redirect_to overviews_path, notice: 'ContentPart was successfully created.'
    else
      redirect_to overviews_path, alert: 'ContentPart was not created.'
    end
  end

  def update
    respond_to do |format|
      if @content_part.update(content_part_params)
        format.html { redirect_to overviews_path, notice: 'ContentPart was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @content_part.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'ContentPart was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @content_part.pages << @page
    end
  end

  def set_content_part
    @content_part = ContentPart.find(params[:id])
  end

  def content_part_params
    params.require(:content_part).permit(:title,
      :text,
      :position,
      :index,
      :template_element_id,
      :image,
      :remove_image,
      :type,
      :video,
      :data_text,
      :remove_video,
      :page_ids => []).tap do |param|
        if param[:template_element_id].blank? || param[:template_element_id].eql?("nil")
          param[:template_element_id] = nil
        end
        if param[:page_ids] && ContentPart::FILES.include?(param[:type])
          param.delete(:page_ids)
        end
      end
  end
end
