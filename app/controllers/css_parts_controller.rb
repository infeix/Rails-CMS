class CssPartsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_css_part, only: [:show, :edit, :update, :destroy]

  # GET /css_parts
  # GET /css_parts.json
  def index
    @css_parts = CssPart.all
  end

  # GET /css_parts/1
  # GET /css_parts/1.json
  def show
  end

  # GET /css_parts/new
  def new
    @css_part = CssPart.new
  end

  # GET /css_parts/1/edit
  def edit
  end

  # POST /css_parts
  # POST /css_parts.json
  def create
    @css_part = CssPart.new(css_part_params)

    respond_to do |format|
      if @css_part.save
        format.html { redirect_to @css_part, notice: 'Css part was successfully created.' }
        format.json { render :show, status: :created, location: @css_part }
      else
        format.html { render :new }
        format.json { render json: @css_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /css_parts/1
  # PATCH/PUT /css_parts/1.json
  def update
    respond_to do |format|
      if @css_part.update(css_part_params)
        format.html { redirect_to @css_part, notice: 'Css part was successfully updated.' }
        format.json { render :show, status: :ok, location: @css_part }
      else
        format.html { render :edit }
        format.json { render json: @css_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /css_parts/1
  # DELETE /css_parts/1.json
  def destroy
    @css_part.destroy
    respond_to do |format|
      format.html { redirect_to css_parts_url, notice: 'Css part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_css_part
      @css_part = CssPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def css_part_params
      params.require(:css_part).permit(:index, :text, :is_last)
    end
end