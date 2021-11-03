# frozen_string_literal: true

module GraphqlError
  class ArgumentError < GraphQL::ExecutionError
    def initialize(message = 'Argument Invalid')
      super(message)
    end

    def to_h
      super.merge({ 'extensions' => { 'code' => 'ARGUMENT_INVALID' } })
    end
  end
end
