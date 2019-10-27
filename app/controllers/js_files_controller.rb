# frozen_string_literal: true

class JsFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  before_action :set_js_file, only: [:show, :edit, :update, :destroy]

  def index
    @js_files = CssFile.all
  end

  def show
  end

  def new
    @js_file = CssFile.new
    find_page
  end

  def edit
  end

  def create
    @js_file = CssFile.new(js_file_params)

    respond_to do |format|
      if @js_file.save
        format.html { redirect_to overviews_path, notice: 'CssFile was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    if @js_file.update(js_file_params)
      redirect_to overviews_path, notice: 'CssFile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @js_file.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'CssFile was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @js_file.pages << @page
    end
  end

  def set_js_file
    @js_file = CssFile.find(params[:id])
  end

  def js_file_params
    params.require(:js_file).permit(
      :title,
      :text,
      :target_path,
      :position,
      :index,
      :template_element_id,
      :js,
      :remove_js,
      :video,
      :data_text,
      :remove_video,
      :page_ids => []).tap do |param|
        if param[:page_ids].blank?
          param[:page_ids] = []
        end
        if param[:template_element_id].blank? || param[:template_element_id].eql?("nil")
          template = param[:position].blank? ? nil : TemplateElement.where(title: param[:position]).first
          if template
            param[:template_element_id] = template.id
          else
            param.delete(:template_element_id)
          end
        end
      end
  end
end
