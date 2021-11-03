# frozen_string_literal: true

module GraphqlError
  class RecordNotFoundError < GraphQL::ExecutionError
    def initialize(message:)
      super(message)
    end

    def to_h
      super.merge({ 'extensions' => { 'code' => 'RECORD_NOT_FOUND' } })
    end
  end
end
