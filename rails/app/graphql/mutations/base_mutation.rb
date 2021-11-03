# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    include ArgumentCheck
    include BalanceCheck
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class InputTypes::BaseInputObject
    object_class Types::BaseObject
  end
end
