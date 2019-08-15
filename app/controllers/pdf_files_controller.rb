# frozen_string_literal: true

class PdfFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_pdf_file, only: [:show, :edit, :update, :destroy]

  def index
    @pdf_files = PdfFile.all
  end

  def show
  end

  def new
    @pdf_file = PdfFile.new
    find_page
  end

  def edit
  end

  def create
    @pdf_file = PdfFile.new(pdf_file_params)

    respond_to do |format|
      if @pdf_file.save
        format.html { redirect_to overviews_path, notice: 'PdfFile was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pdf_file.update(pdf_file_params)
        format.html { redirect_to overviews_path, notice: 'PdfFile was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pdf_file.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'PdfFile was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @pdf_file.page = @page
    end
  end

  def set_pdf_file
    @pdf_file = PdfFile.find(params[:id])
  end

  def pdf_file_params
    params.require(:pdf_file).permit(
      :title,
      :text,
      :target_path,
      :position,
      :page_id,
      :template_element_id,
      :pdf,
      :remove_pdf,
      :video,
      :remove_video).tap do |param|
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
