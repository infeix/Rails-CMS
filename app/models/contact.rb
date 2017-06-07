# frozen_string_literal: true

class Contact < ActiveRecord::Base
  has_many :send_invoices, class_name: :Invoice,
                           inverse_of: :from,
                           foreign_key: :from_id
  has_many :received_invoices, class_name: :Invoice,
                               inverse_of: :to,
                               foreign_key: :to_id
end
