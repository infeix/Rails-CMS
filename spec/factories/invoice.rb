# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    number { Faker::Number.number(10).to_s }
    to_id { build :contact }
    from_id { build :contact }
    document_template
    send_date { Faker::Date.backward(100) }
  end
end
