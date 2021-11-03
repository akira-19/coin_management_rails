# frozen_string_literal: true

module BalanceCheck
  extend ActiveSupport::Concern

  def balance_checker(user:, amount:)
    current_balance = ::Organizers::FetchCurrentBalance.call(user: user).balance
    raise ::GraphqlError::ArgumentError.new(message: 'amount must be equal or less than current balance') if (current_balance - amount).negative?

    nil
  end
end
