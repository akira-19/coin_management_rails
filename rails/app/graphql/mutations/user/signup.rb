# frozen_string_literal: true

module Mutations
  module User
    class Signup < BaseMutation
      argument :name, String, required: true
      field :user, ObjectTypes::UserType, null: false

      def resolve(name:)
        # concern（ArgumentCheck）で処理
        blank_chekcer(arg_value: name, arg_name: 'name')

        user = ::User.create!(name: name)
        {
          user: user
        }
      end
    end
  end
end
