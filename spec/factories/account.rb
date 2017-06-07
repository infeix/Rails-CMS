 # frozen_string_literal: true

FactoryGirl.define do
  factory :account do
    starting_level { 0 }
    name { Faker::Lorem.word }
  end
end
