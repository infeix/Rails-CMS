class Templates::HtmlPartsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_html_part, only: [:show, :edit, :update, :destroy]

  def show
    find_template
  end

  def new
    @html_part = HtmlPart.new
    find_template
    last_index = @template.last_index_of :html_part
    @html_part.index = last_index + 1
    last_index = last_index + 1
    @html_part.is_last = true
    @html_part.save

    reset_index

    redirect_to edit_template_path(@template), notice: 'Html part was successfully created.'
  end

  def edit
  end

  def create
    @html_part = HtmlPart.new(html_part_params)

    if @html_part.save
      redirect_to overviews_path, notice: 'Html part was successfully created.'
    else
      render :new
    end
  end

  def update
    if @html_part.update(html_part_params)
      redirect_to overviews_path, notice: 'Html part was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    template = @html_part.template
    @html_part.destroy
    if template.html_parts.count > 0
      reset_index
    end

    redirect_to template_path(template), notice: 'Html part was successfully destroyed.'
  end

  private

  def reset_index
    template = @html_part.template
    template = template.reload
    index_count = 1
    template.html_parts.each do |element|
      element.index = index_count
      index_count = index_count + 1
      element.is_last = false
      element.save
    end
    element = template.html_parts.last
    element.is_last = true
    element.save
  end

  def find_template
    if params[:template_id].present?
      @template = Template.find_by!(id: params[:template_id])
      @html_part.template = @template
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_html_part
    @html_part = HtmlPart.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def html_part_params
    params.require(:html_part).permit(:index, :template_id, :text, :is_last)
  end
end
