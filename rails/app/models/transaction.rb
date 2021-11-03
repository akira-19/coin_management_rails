# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: :from_id, optional: true, inverse_of: :send_transactions
  belongs_to :receiver, class_name: 'User', foreign_key: :to_id, optional: true, inverse_of: :receive_transactions
end
