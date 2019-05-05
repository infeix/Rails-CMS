# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :create

  BLLACKLIST = %w(http sex).freeze

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    if blacklist_exluded_in(@message.msg) && @message.save
      redirect_to root_path, notice: 'Die Nachricht wurde erfolgreich gesendet.'
    else
      redirect_to root_path, notice: 'Die Nachricht konnte nicht gesendet werden.'
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to overviews_path, notice: 'Message was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to overviews_path, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def blacklist_exluded_in(msg)
      BLLACKLIST.each do |element|
        return false if msg.downcase.include? element
      end
      true
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:msg, :name, :email)
    end
end
