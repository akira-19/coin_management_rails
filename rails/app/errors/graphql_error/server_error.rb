# frozen_string_literal: true

module GraphqlError
  class ServerError < GraphQL::ExecutionError
    def initialize
      super('Internal Server Error')
    end

    def to_h
      super.merge({ 'extensions' => { 'code' => 'INTERNAL_SERVER_ERROR' } })
    end

    private

    attr_reader :code
  end
end
