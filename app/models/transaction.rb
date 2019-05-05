# frozen_string_literal: true

class Transaction < ActiveRecord::Base
  belongs_to :from, class_name: 'Account'
  belongs_to :to, class_name: 'Account'

  scope :by_account, ->(account_id) { where('from_id = ? OR to_id = ?', account_id, account_id).order(:invoice_date) }
  scope :sort_by_date, ->() { order(:invoice_date) }
  scope :in_year, ->(year) { order(:invoice_date) }

  def other_account(account)
    if from? account then
      to
    elsif to? account then
      from
    else
      nil
    end
  end

  def to?(account)
    account.id == to.id
  end

  def from?(account)
    account.id == from.id
  end
end
