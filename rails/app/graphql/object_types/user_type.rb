# frozen_string_literal: true

module ObjectTypes
  class UserType < Types::BaseObject
    implements InterfaceTypes::ActiveRecordInterface

    field :name, String, null: false
    field :balance, Int, null: false

    def balance
      ::Organizers::FetchCurrentBalance.call(user: object).balance
    end
  end
end
