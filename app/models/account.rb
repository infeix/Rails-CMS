# frozen_string_literal: true

class Account < ActiveRecord::Base
  has_many :expenses, class_name: 'Transaction', foreign_key: 'from_id'
  has_many :incomes, class_name: 'Transaction', foreign_key: 'to_id'
  has_many :income_accounts, through: :incomes, class_name: 'Account'
  has_many :expense_accounts, through: :expenses, class_name: 'Account'

  def current_level
    level = starting_level
    expenses.each do |transaction|
      level -= transaction.total
    end

    incomes.each do |transaction|
      level += transaction.total
    end
    level
  end

  def all_transactions
    Transaction.by_account id
  end
end
