# frozen_string_literal: true

module Mutations
  module Transaction
    class AddCoins < BaseMutation
      argument :user_id, ID, required: true
      argument :amount, Int, required: true
      field :transaction, ObjectTypes::TransactionType, null: false

      def resolve(user_id:, amount: 0)
        # concern（ArgumentCheck）で処理
        zero_or_less_chekcer(amount: amount)

        # Modelで処理
        user = ::User.find_user(id: user_id)

        transaction = user.receive_transactions.create!(amount: amount)
        {
          transaction: transaction
        }
      end
    end
  end
end
