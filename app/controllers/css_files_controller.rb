# frozen_string_literal: true

class CssFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  before_action :set_css_file, only: [:show, :edit, :update, :destroy]

  def index
    @css_files = CssFile.all
  end

  def show
    @css_file.read_data unless @css_file.data_text.eql? @css_file.file_data
  end

  def new
    @css_file = CssFile.new
    find_page
  end

  def edit
    @css_file.read_data unless @css_file.data_text.eql? @css_file.file_data
  end

  def create
    @css_file = CssFile.new(css_file_params)

    if @css_file.save
      @css_file.read_data
      redirect_to overviews_path, notice: 'CssFile was successfully created.'
    else
      render :new
    end
  end

  def update
    if @css_file.update(css_file_params)
      if css_file_params['css_file'].present?
        @css_file.read_data
      else
        @css_file.write_data
      end
      redirect_to overviews_path, notice: 'CssFile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @css_file.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'CssFile was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @css_file.pages << @page
    end
  end

  def set_css_file
    @css_file = CssFile.find(params[:id])
  end

  def css_file_params
    params.require(:css_file).permit(
      :title,
      :text,
      :target_path,
      :position,
      :index,
      :template_element_id,
      :css_file,
      :remove_css_file,
      :video,
      :data_text,
      :remove_video,
      :page_ids => []).tap do |param|
        if param[:page_ids].blank?
          param[:page_ids] = []
        end
      end
  end
end
