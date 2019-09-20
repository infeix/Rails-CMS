# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def authenticate_admin!
    if current_user.is_admin?
      true
    else
      redirect_to user_session_path unless current_user.is_admin?
      false
    end
  end

  def index
    @users = if current_user.is_admin?
      User.all
    else
      User.where(id: current_user.id)
    end
  end

  def show
  end

  def new
    return unless authenticate_admin!
    @user = User.new
  end

  def edit
  end

  def create
    return unless authenticate_admin!
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to overviews_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    return unless authenticate_admin!
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to overviews_path, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    return unless authenticate_admin!
    @user.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'User was successfully destroyed.' }
    end
  end

  private

  def set_user
    @user = if current_user.is_admin?
      User.find(params[:id])
    else
      current_user
    end
  end

  def user_params
    params.require(:user).permit(:is_admin, :is_agent, :is_subscriber, :lang, :name)
  end
end
