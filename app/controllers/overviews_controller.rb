class OverviewsController < ApplicationController

  def index
    @pages = Page.all
    @templates = Template.all
    @articles = Article.all
  end
end
