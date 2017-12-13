# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    total { Faker::Number.number(10) }
    name { Faker::Lorem.word }
    invoice_date { 1.day.ago.beginning_of_day }
    from_id { build :account }
    to_id { build :account }
  end
end
