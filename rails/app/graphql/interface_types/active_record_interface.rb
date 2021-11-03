# frozen_string_literal: true

module InterfaceTypes
  module ActiveRecordInterface
    include InterfaceTypes::BaseInterface
    description 'Active Record Interface'

    field :id, ID, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
