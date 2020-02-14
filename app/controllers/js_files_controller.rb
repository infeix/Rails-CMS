# frozen_string_literal: true

class JsFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  before_action :set_js_file, only: [:show, :edit, :update, :destroy]

  def index
    @js_files = JsFile.all
  end

  def show
    @js_file.read_data unless @js_file.data_text.eql? @js_file.file_data
  end

  def new
    @js_file = JsFile.new
    find_page
  end

  def edit
    @js_file.read_data unless @js_file.data_text.eql? @js_file.file_data
  end

  def create
    @js_file = JsFile.new(js_file_params)

    if @js_file.save
      @js_file.read_data
      redirect_to overviews_path, notice: 'JsFile was successfully created.'
    else
      render :new
    end
  end

  def update
    if @js_file.update(js_file_params)
      if js_file_params['js_file'].present?
        @js_file.read_data
      else
        @js_file.write_data
      end

      redirect_to overviews_path, notice: 'JsFile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @js_file.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'JsFile was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      ContetnPartPage.create_or_find_by(page_id: @page.id, content_part_id: @js_file.id)
    end
  end

  def set_js_file
    @js_file = JsFile.find(params[:id])
  end

  def js_file_params
    params.require(:js_file).permit(
      :title,
      :text,
      :target_path,
      :position,
      :index,
      :template_element_id,
      :js_file,
      :remove_js_file,
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