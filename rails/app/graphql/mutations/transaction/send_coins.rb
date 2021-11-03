# frozen_string_literal: true

module Mutations
  module Transaction
    class SendCoins < BaseMutation
      argument :sender_id, ID, required: true
      argument :receiver_id, ID, required: true
      argument :amount, Int, required: true
      field :transaction, ObjectTypes::TransactionType, null: false

      def resolve(sender_id:, receiver_id:, amount:)
        # concern（ArgumentCheck）で処理
        zero_or_less_chekcer(amount: amount)

        # Modelで処理
        sender = ::User.find_sender(id: sender_id)
        receiver = ::User.find_receiver(id: receiver_id)

        # concern（BalanceCheck）で処理
        balance_checker(user: sender, amount: amount)

        transaction = ::Transaction.create!(from_id: sender.id, to_id: receiver.id, amount: amount)
        {
          transaction: transaction
        }
      end
    end
  end
end
