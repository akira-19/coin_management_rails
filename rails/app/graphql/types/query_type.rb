# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # User
    field :user, resolver: Queries::User::User

    # Transaction
    field :transactions_by_user, resolver: Queries::Transaction::TransactionsByUser
  end
end
