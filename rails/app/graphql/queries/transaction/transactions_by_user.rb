# frozen_string_literal: true

module Queries
  module Transaction
    class TransactionsByUser < BaseQuery
      description 'query transactions'
      argument :user_id, ID, required: true
      type ObjectTypes::TransactionType.connection_type, null: false

      def resolve(user_id:)
        # Modelで処理
        user = ::User.find_user(id: user_id)

        ::Transaction.where(sender: user).or(::Transaction.where(receiver: user)).order(created_at: :desc)
      end
    end
  end
end
