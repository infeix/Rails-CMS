# frozen_string_literal: true

class ContentPartsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  before_action :set_content_part, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to overviews_url
  end

  def show
  end

  def new
    @content_part = ContentPart.new
    @content_part.type = 'Textelement'
    find_page
  end

  def edit
  end

  def create
    @content_part = ContentPart.new content_part_params

    if @content_part.save
      redirect_to overviews_path, notice: 'ContentPart was successfully created.'
    else
      render :new
    end
  end

  def copy
    @content_part = ContentPart.new content_part_params

    if @content_part.save
      redirect_to overviews_path, notice: 'ContentPart was successfully created.'
    else
      render :new
    end
  end

  def update
    if @content_part.update(content_part_params)
      redirect_to overviews_path, notice: 'ContentPart was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @content_part.destroy
    redirect_to overviews_path, notice: 'ContentPart was successfully destroyed.'
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by! id: params[:page_id]
      ContentPartPage.find_or_create_by page_id: @page.id, content_part_id: @content_part.id
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
      :video,
      :data_text,
      :remove_video,
      :type,
      :page_ids => []).tap do |param|
        if param[:template_element_id].blank? || param[:template_element_id].eql?("nil")
          param[:template_element_id] = nil
        end
      end
  end
end
