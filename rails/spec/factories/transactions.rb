# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transaction_type { 0 }
    from_id { nil }
    to_id { nil }
    amount { 1 }
  end
end
