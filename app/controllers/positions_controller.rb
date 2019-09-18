# frozen_string_literal: true

class PositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  before_action :set_position, only: [:destroy]

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  def new
    Position.all.each do |position|
      position.destroy
    end
    ContentPart.all.each do |part|
      part.create_positions
    end
    PagePart.all.each do |part|
      part.create_positions
    end
    Position.find_or_create_by(name: "no_position")
    redirect_to overviews_path, notice: 'Positions were successfully updated.'
  end

  def destroy
    @position.destroy
    redirect_to overviews_path, notice: 'Position was successfully destroyed.'
  end

  private

  def set_position
    @position = Position.find(params[:id])
  end
end
