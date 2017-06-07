# frozen_string_literal: true

FactoryGirl.define do
  factory :document_template do
    template { Faker::Lorem.word }
  end
end
