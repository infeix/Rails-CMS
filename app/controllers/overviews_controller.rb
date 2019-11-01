# frozen_string_literal: true

class OverviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_agent!

  def index
    year = params[:year]
    page = params[:page_id] || Page.currentEditingOne&.id
    page = nil if page.eql?('nil')
    content_part_id = params[:content_part_id] || ContentPart.currentEditingOne&.id
    content_part_id = nil if content_part_id.eql?('nil')

    @pages = Page.all.sort_by_id
    if(page)
      current_edit_page = Page.currentEditingOne
      unless current_edit_page.nil?
        current_edit_page.edit_filter = 0
        current_edit_page.save
      end

      @page = Page.find_by(id: page)
      @page.edit_filter = 1
      @page.save

      if(content_part_id)
        @content_part = ContentPart.find_by(id: content_part_id)
        @content_part.edit_filter = 1
        @content_part.save
        @content_parts = ContentPart.where(id: @content_part.id)
      else
        @content_part = ContentPart.currentEditingOne
        unless @content_part.nil?
          @content_part.edit_filter = 0
          @content_part.save
        end
        @content_parts = ContentPart.includes(:pages).where(pages: {id: @page.id})
      end
      @templates = TemplateElement.where(id: @page.template_element_id).sort_by_id
    else
      page = Page.currentEditingOne
      unless page.nil?
        page.edit_filter = 0
        page.save
      end

      @content_part = ContentPart.currentEditingOne
      unless @content_part.nil?
        @content_part.edit_filter = 0
        @content_part.save
      end
      @content_parts = ContentPart.all
      @templates = TemplateElement.all.sort_by_id
    end

    @html_parts = HtmlPart.all.sort_by_index
    @css_parts = CssPart.all.sort_by_index
    @messages = Message.all
    @users = User.all
    @positions = Position.sort_by_name

    @invoices = Invoice.all.sort_by_send_date
    @document_templates = DocumentTemplate.all
    @contacts = Contact.all
    @services = Service.all
    @transactions = Transaction.in_year(year).sort_by_date
    @accounts = Account.all
  end
end
