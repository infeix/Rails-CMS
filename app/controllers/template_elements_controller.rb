# frozen_string_literal: true

class TemplateElementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_agent!

  before_action :set_template, only: [:show, :edit, :update, :destroy, :copy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = TemplateElement.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = TemplateElement.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = TemplateElement.new(template_element_params)

    if @template.save
      redirect_to overviews_path(:anchor => "admin"), notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    if @template.update(template_element_params)
      @template.reload if @template.remove_empty_css
      redirect_to overviews_path(:anchor => "admin"), notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  def copy
    new_template_element = @template.make_a_copy
    @template = new_template_element
    redirect_to edit_template_element_path(@template), notice: 'Template was successfully copied.'
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    redirect_to overviews_path(:anchor => "admin"), notice: 'Template was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_template
    @template = TemplateElement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def template_element_params
    unless params[:action].eql?('copy')
      params.require(:template_element).permit(
          :title,
          :meta,
          :target_type,
          html_parts_attributes: [:id, :index, :text, :is_last],
          css_parts_attributes: [:id, :index, :text])
    else
      params.permit(:template_element).permit(
          :title,
          :meta,
          :target_type,
          html_parts_attributes: [:id, :index, :text, :is_last],
          css_parts_attributes: [:id, :index, :text])
    end
  end
end
