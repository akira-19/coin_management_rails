# frozen_string_literal: true

class User < ApplicationRecord
  has_many :send_transactions, lambda {
                                 where('from_id is not NULL')
                               }, class_name: 'Transaction', foreign_key: :from_id, dependent: :restrict_with_exception, inverse_of: :sender
  has_many :receive_transactions, lambda {
                                    where('to_id is not NULL')
                                  }, class_name: 'Transaction', foreign_key: :to_id, dependent: :restrict_with_exception, inverse_of: :receiver
  has_many :daily_balances, dependent: :restrict_with_exception

  validates :name, presence: true

  def self.find_user(id:)
    user = find_by(id: id)
    raise ::GraphqlError::RecordNotFoundError.new(message: 'User not found') unless user

    user
  end

  def self.find_sender(id:)
    sender = find_by(id: id)
    raise ::GraphqlError::RecordNotFoundError.new(message: 'Sender not found') unless sender

    sender
  end

  def self.find_receiver(id:)
    receiver = find_by(id: id)
    raise ::GraphqlError::RecordNotFoundError.new(message: 'Receiver not found') unless receiver

    receiver
  end
end
