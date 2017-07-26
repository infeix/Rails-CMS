# app/decorators/article_decorator.rb
class TransactionDecorator < Draper::Decorator
  delegate_all

  def render_in_account(account, rows)
    row_index = rows[other_account(account).id]
    to = to?(account)
    before = '<div class="transaction-row"></div>' * (row_index - 1)
    after = '<div class="transaction-row"></div>' * (rows.count - row_index)
    "<div class=\"transaction-row\">#{name}</div><div class=\"transaction-row\">#{invoice_date}</div>#{before}<div class=\"transaction-row\">#{sign(to)}#{total}</div>#{after}<div class=\"float-reset\"></div>"
  end

  def sign(to)
    if to
      '+'
    else
      '-'
    end
  end
end
