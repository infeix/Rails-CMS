class OverviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to user_session_path unless current_user.is_admin?
  end

  def index
    @pages = Page.all
    @templates = Template.all
    @articles = Article.all
    @html_parts = HtmlPart.all
    @css_parts = CssPart.all
  end
end
