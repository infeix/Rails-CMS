# frozen_string_literal: true

class OverviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_agent!

  def index
    year = params[:year]
    content_part_type = params[:content_part_type]
    content_part_position = params[:content_part_position]
    page_id = params[:page_id] || Page.current_editing_one&.id
    page_id = nil if page_id.eql?('nil')

    content_part_id = params[:content_part_id] || ContentPart.current_editing_one&.id
    content_part_id = nil if content_part_id.eql?('nil')

    @pages = Page.all.sort_by_id
    @files = ContentPart.files.sort_by_title

    if content_part_id.eql? 'new'
      @content_part = ContentPart.new
      @content_part.edit_filter = 1
      @content_part.type = content_part_type
      @content_part.position = content_part_position
    elsif content_part_id
      @content_part = ContentPart.find_by(id: content_part_id)
      @content_part.edit_filter = 1
      @content_part.save
    else
      @content_part = ContentPart.current_editing_one
      unless @content_part.nil?
        @content_part.edit_filter = 0
        @content_part.save
      end
    end

    if page_id
      current_edit_page = Page.current_editing_one
      unless current_edit_page.nil?
        current_edit_page.edit_filter = 0
        current_edit_page.save
      end

      @page = Page.find_by(id: page_id)
      @page.edit_filter = 1
      @page.save

      @content_parts = ContentPart.where(page: @page).or(ContentPart.where(page: nil))
      @templates = TemplateElement.where(id: @page.template_element_id).sort_by_id
    elsif page_id.nil?
      page = Page.current_editing_one
      unless page.nil?
        page.edit_filter = 0
        page.save
      end

      content_part = ContentPart.current_editing_one
      if content_part && !content_part&.is_file?
        content_part.edit_filter = 0
        content_part.save
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
