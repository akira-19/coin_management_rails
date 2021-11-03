# frozen_string_literal: true

module Queries
  module User
    class User < BaseQuery
      description 'find user'
      argument :user_id, ID, required: true
      type ObjectTypes::UserType, null: false

      def resolve(user_id:)
        # Modelで処理
        ::User.find_user(id: user_id)
      end
    end
  end
end
