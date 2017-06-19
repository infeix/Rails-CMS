# frozen_string_literal: false

require 'digest'

class DocumentTemplate < ActiveRecord::Base
  has_many :invoices

  def render(invoice)
    template.gsub! '--FROM-NAME--', invoice.from.name
    template.gsub! '--FROM-STREET--', invoice.from.street
    template.gsub! '--FROM-CITY--', invoice.from.city
    template.gsub! '--FROM-PHONE--', invoice.from.phone
    template.gsub! '--FROM-MAIL--', invoice.from.mail
    template.gsub! '--FROM-IBAN--', invoice.from.bank_account_nr
    template.gsub! '--FROM-BANK-NAME--', invoice.from.bank_name
    template.gsub! '--FROM-TAX-ID--', invoice.from.tax_nr

    template.gsub! '--TO-NAME--', invoice.to.name
    template.gsub! '--TO-STREET--', invoice.to.street
    template.gsub! '--TO-CITY--', invoice.to.city

    template.gsub! '--INVOICE-NUMBER--', invoice.number
    template.gsub! '--DATE--', invoice.send_date.strftime('%d.%m.%Y')

    all_services = ''

    invoice.services.each do |service|
      all_services << " #{service.amount} &"
      all_services << " #{service.unit} &"
      all_services << " #{service.description} &"
      all_services << " \\multicolumn{1}{r}{#{sprintf('%.2f', service.price_per_unit)} EUR} &"
      all_services << " \\multicolumn{1}{r}{#{sprintf('%.2f', service.price_total)} EUR} \\\\\\\\ \\hline\r\n"
    end

    template.gsub! '--ALL-SERVICES--', all_services

    template.gsub! '--TAX-OF-ALL--', sprintf('%.2f', invoice.tax)
    template.gsub! '--TOTAL-OF-ALL--', sprintf('%.2f', invoice.total)
    template.gsub! '--TOTAL-OF-ALL-WITH-TAX--', sprintf('%.2f', invoice.total_with_tax)
    md5 = Digest::MD5.new
    md5.update template
    template.gsub! '--INVOICE-HASH--', md5.hexdigest.upcase[0..8]
    template
  end
end
