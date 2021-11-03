# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name, 'user_1')
  end
end
