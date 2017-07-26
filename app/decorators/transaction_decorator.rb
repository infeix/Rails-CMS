# app/decorators/article_decorator.rb
class TransactionDecorator < Draper::Decorator
  delegate_all

  def render_in_row(row_index, to)
    before = '<div class="transaction-row"></div>' * (row_index - 1)
    "<div class=\"transaction-row\">#{invoice_date}</div>#{before}<div class=\"transaction-row\">#{sign(to)}#{total}</div><div class=\"float-reset\"></div>"
  end

  def sign(to)
    if to
      '+'
    else
      '-'
    end
  end
end
