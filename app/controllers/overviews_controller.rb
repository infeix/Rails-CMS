# frozen_string_literal: true

class OverviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  def index
    @pages = Page.all
    @templates = Template.all
    @articles = Article.all.sort_by_index
    @html_parts = HtmlPart.all.sort_by_index
    @css_parts = CssPart.all.sort_by_index
    @messages = Message.all
    @users = User.all

    @invoices = Invoice.all
    @document_templates = DocumentTemplate.all
    @contacts = Contact.all
    @services = Service.all
    @transactions = Transaction.all
    @accounts = Account.all
  end
end
