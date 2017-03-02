class HtmlPartsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_html_part, only: [:show, :edit, :update, :destroy]

  # GET /html_parts
  # GET /html_parts.json
  def index
    @html_parts = HtmlPart.all
  end

  # GET /html_parts/1
  # GET /html_parts/1.json
  def show
  end

  # GET /html_parts/new
  def new
    @html_part = HtmlPart.new
  end

  # GET /html_parts/1/edit
  def edit
  end

  # POST /html_parts
  # POST /html_parts.json
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

  # PATCH/PUT /html_parts/1
  # PATCH/PUT /html_parts/1.json
  def update
    respond_to do |format|
      if @html_part.update(html_part_params)
        format.html { redirect_to overviews_path, notice: 'Html part was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /html_parts/1
  # DELETE /html_parts/1.json
  def destroy
    @html_part.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Html part was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_html_part
      @html_part = HtmlPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def html_part_params
      params.require(:html_part).permit(:index, :text, :is_last)
    end
end
