# frozen_string_literal: true

class UrlelementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  before_action :set_urlelement, only: [:show, :edit, :update, :destroy]

  def index
    @urlelements = Urlelement.all
  end

  def show
  end

  def new
    @urlelement = Urlelement.new
    find_page
  end

  def edit
  end

  def create
    @urlelement = Urlelement.new(urlelement_params)

    respond_to do |format|
      if @urlelement.save
        format.html { redirect_to overviews_path, notice: 'Urlelement was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @urlelement.update(urlelement_params)
        format.html { redirect_to overviews_path, notice: 'Urlelement was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @urlelement.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Urlelement was successfully destroyed.' }
    end
  end

  private

  def find_page
    if params[:page_id].present?
      @page = Page.find_by!(id: params[:page_id])
      @urlelement.page = @page
    end
  end

  def set_urlelement
    @urlelement = Urlelement.find(params[:id])
  end

  def urlelement_params
    params.require(:urlelement).permit(
      :title,
      :text,
      :target_path,
      :position,
      :page_id,
      :template_element_id,
      :image,
      :remove_image,
      :video,
      :remove_video).tap do |param|
        binding.pry
        if param[:template_element_id].eql?("nil")
          param.delete(:template_element_id)
        end
      end
  end
end
