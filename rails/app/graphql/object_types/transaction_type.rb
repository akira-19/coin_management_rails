# frozen_string_literal: true

module ObjectTypes
  class TransactionType < Types::BaseObject
    implements InterfaceTypes::ActiveRecordInterface

    field :sender, ObjectTypes::UserType, null: true
    field :receiver, ObjectTypes::UserType, null: true
    field :amount, Int, null: false
  end
end
