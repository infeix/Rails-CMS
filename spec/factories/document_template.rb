# frozen_string_literal: true

FactoryBot.define do
  factory :document_template do
    template { Faker::Lorem.word }
  end
end
