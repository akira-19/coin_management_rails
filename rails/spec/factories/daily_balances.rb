# frozen_string_literal: true

FactoryBot.define do
  factory :daily_balance do
    user { nil }
    balance { 0 }
    target_date { '2021-10-31' }
  end
end
