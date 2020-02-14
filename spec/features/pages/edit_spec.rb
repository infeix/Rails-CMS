# frozen_string_literal: true

require 'rails_helper'
require 'uri'

RSpec.feature 'Page edit page' do
  let!(:user) { create :user }
  let!(:template_element) { create :template_element }
  let!(:index_page) { create :page, path: 'index', template_element: template_element }

  scenario 'get to login page when not logged in' do
    visit new_page_path
    expect(page.current_path).to eq new_user_session_path
  end

  scenario 'navigating to the edit page via index' do
    expect(Page.count).to eq 1
    expect(User.count).to eq 1
    visit new_user_session_path
    find('#user_email').set user.email
    find('#user_password').set 'secret42'
    page.find("input[type='submit']").click

    expect(page.current_path).to eq root_path

    visit overviews_path
    page.find('.new-page-button').click
    expect(page.current_path).to eq new_page_path

    find('.page_title').set 'blub_title'
    find('#page_path').set 'blub_path'
    find('#page_template_element_id').set template_element.id

    page.find("input[type='submit']").click
    expect(page.current_path).to eq overviews_path

    page_element = Page.where('"pages"."path" != ?', 'index').first
    expect(page_element.title).to eq 'blub_title'
  end

#    scenario 'navigating to the edit page via show' do
#      visit dashboard_path
#
#      page.find('.my-search-requests--link').click
#      expect(page.find('.title')).to have_text 'Suchanfragen'
#      page.find('.search-request .search-request--show-link').click
#      expect(page.find('.title')).to have_text "Suchanfrage #{search_request.reference_code}"
#
#      page.find('.search-request .search-request--edit-link').click
#      expect(page.find('.title')).to have_text 'Suchanfrage bearbeiten'
#      expect(page.current_path).to eq edit_company_search_request_path(search_request)
#    end
#
#    scenario 'editing a search_request' do
#      expect(naseweis_profession).to be_present
#      visit edit_company_search_request_path(search_request)
#
#      within('.search-request') do
#        # editing, but with a wrong train-type
#        find('.search-request--customer-reference').set 'Lollipops'
#        find("#search_request_profession_id_#{naseweis_profession.id}").set(true)
#        find('.search-request--train-type').set ''
#        submit_form
#
#        # finding and fixing the validation error
#        find('.search-request--train-type:invalid')
#        find('.search-request--train-type').set 'Steamtrain'
#        submit_form
#      end
#
#      expect(page.find('.title')).to have_text 'Suchanfragen'
#      expect(page.current_path).to eq company_search_requests_path
#      expect(page.find('.search-request .search-request--customer-reference')).to have_text 'Lollipops'
#      expect(page.find('.search-request .search-request--profession')).to have_text 'Naseweis'
#    end
#
#    context 'when the offer was already published' do
#      let(:search_request) { offer.search_request }
#      let(:offer) { create :offer }
#
#      scenario 'cannot edit via index' do
#        visit dashboard_path
#        page.find('.my-search-requests--link').click
#        expect(page.find('.title')).to have_text 'Suchanfragen'
#
#        expect(page).not_to have_selector('.search-request .search-request--edit-link')
#      end
#
#      scenario 'cannot edit via show' do
#        visit dashboard_path
#
#        page.find('.my-search-requests--link').click
#        expect(page.find('.title')).to have_text 'Suchanfragen'
#        page.find('.search-request .search-request--show-link').click
#        expect(page.find('.title')).to have_text "Suchanfrage #{search_request.reference_code}"
#
#        expect(page).not_to have_selector('.search-request .search-request--edit-link')
#      end
#    end
end
