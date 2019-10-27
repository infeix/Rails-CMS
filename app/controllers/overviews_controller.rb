# frozen_string_literal: true

class OverviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_agent!

  def index
    year = params[:year]
    page = params[:page_id] || Page.editingPage&.id
    page = nil if page.eql?('nil')

    @pages = Page.all.sort_by_id
    if(page)
      current_edit_page = Page.editingPage
      unless current_edit_page.nil?
        current_edit_page.edit_filter = 0
        current_edit_page.save
      end
      @page = Page.find_by(id: page)
      @page.edit_filter = 1
      @page.save
      @articles = Article.where(page: @page).sort_by_index
      @pictures = Picture.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @videoelements = Videoelement.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @textelements = Textelement.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @urlelements = Urlelement.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @pdf_files = PdfFile.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @css_files = CssFile.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @js_files = JsFile.includes(:pages).where(pages: {id: @page.id}).sort_by_index
      @templates = TemplateElement.where(id: @page.template_element_id)
    else
      page = Page.editingPage
      unless page.nil?
        page.edit_filter = 0
        page.save
      end
      @templates = TemplateElement.all.sort_by_id
      @articles = Article.all.sort_by_index
      @pictures = Picture.all.sort_by_index
      @videoelements = Videoelement.all.sort_by_index
      @textelements = Textelement.all.sort_by_index
      @urlelements = Urlelement.all.sort_by_index
      @pdf_files = PdfFile.all.sort_by_index
      @css_files = CssFile.all.sort_by_index
      @js_files = JsFile.all.sort_by_index
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
