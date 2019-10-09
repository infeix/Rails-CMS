# frozen_string_literal: true

class TemplateElementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_agent!

  before_action :set_template, only: [:show, :edit, :update, :destroy]

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

    respond_to do |format|
      if @template.save
        format.html { redirect_to overviews_path, notice: 'Template was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    if @template.update(template_element_params)
      render :edit, notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = TemplateElement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_element_params
      params.require(:template_element).permit(:title, :meta, html_parts_attributes: [:id, :index, :text, :is_last], css_parts_attributes: [:id, :index, :text])
    end
end
