# frozen_string_literal: true

class OverviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  def index
    year = params[:year]
    page = params[:page] || Page.editingPage&.id
    page = nil if page.eql?('nil')

    @pages = Page.all
    @templates = Template.all
    if(page)
      page = Page.find_by(id: page)
      page.edit_filter = 1
      page.save
      @articles = Article.where(page: page).sort_by_index
      @pictures = Picture.where(page: page).sort_by_index
      @videoelements = Videoelement.where(page: page).sort_by_index
      @textelements = Textelement.where(page: page).sort_by_index
      @urlelements = Urlelement.where(page: page).sort_by_index
    else
      page = Page.editingPage
      unless page.nil?
        page.edit_filter = 0
        page.save
      end
      @articles = Article.all.sort_by_index
      @pictures = Picture.all.sort_by_index
      @videoelements = Videoelement.all.sort_by_index
      @textelements = Textelement.all.sort_by_index
      @urlelements = Urlelement.all.sort_by_index
    end
    @html_parts = HtmlPart.all.sort_by_index
    @css_parts = CssPart.all.sort_by_index
    @messages = Message.all
    @users = User.all

    @invoices = Invoice.all.sort_by_send_date
    @document_templates = DocumentTemplate.all
    @contacts = Contact.all
    @services = Service.all
    @transactions = Transaction.in_year(year).sort_by_date
    @accounts = Account.all
  end
end
