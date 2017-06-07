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
  end

  def edit
  end

  def create
    @html_part = HtmlPart.new(html_part_params)

    respond_to do |format|
      if @html_part.save
        format.html { redirect_to overviews_path, notice: 'Html part was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @html_part.update(html_part_params)
        format.html { redirect_to overviews_path, notice: 'Html part was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @html_part.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Html part was successfully destroyed.' }
    end
  end

  private

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
