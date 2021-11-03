# frozen_string_literal: true

module GraphqlError
  class CustomError < GraphQL::ExecutionError
    def initialize(message:, code:)
      @code = code
      super(message)
    end

    def to_h
      super.merge({ 'extensions' => { 'code' => code } })
    end

    private

    attr_reader :code
  end
end
