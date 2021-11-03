# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # User
    field :signup, mutation: Mutations::User::Signup

    # Transaction
    field :add_coins, mutation: Mutations::Transaction::AddCoins
    field :consume_coins, mutation: Mutations::Transaction::ConsumeCoins
    field :send_coins, mutation: Mutations::Transaction::SendCoins
  end
end
