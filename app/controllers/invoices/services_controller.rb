# frozen_string_literal: true

class Invoices::ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @service = Service.new
    set_service
    @service.invoice = @invoice unless @invoice.blank?
  end

  def edit
  end

  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service.invoice, notice: 'Service was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service.invoice, notice: 'Service was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:amount, :unit, :description, :price_per_unit, :invoice_id)
  end
end
