class Templates::CssPartsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_css_part, only: [:show, :edit, :update, :destroy]

  def show
    find_template
  end

  def new
    @css_part = CssPart.new
    find_template
  end

  def edit
  end

  def create
    @css_part = CssPart.new(css_part_params)

    respond_to do |format|
      if @css_part.save
        format.html { redirect_to overviews_path, notice: 'Css part was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @css_part.update(css_part_params)
        format.html { redirect_to overviews_path, notice: 'Css part was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @css_part.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Css part was successfully destroyed.' }
    end
  end

  private

  def find_template
    if params[:template_id].present?
      @template = Template.find_by!(id: params[:template_id])
      @css_part.template = @template
    end
  end

  def set_css_part
    @css_part = CssPart.find(params[:id])
  end

  def css_part_params
    params.require(:css_part).permit(:index, :template_id, :text, :is_last)
  end
end
