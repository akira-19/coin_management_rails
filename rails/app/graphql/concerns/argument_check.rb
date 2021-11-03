# frozen_string_literal: true

module ArgumentCheck
  extend ActiveSupport::Concern

  def blank_chekcer(arg_value:, arg_name:)
    raise ::GraphqlError::ArgumentError.new(message: "Argument #{arg_name} is required") if arg_value.blank?

    nil
  end

  def zero_or_less_chekcer(amount:)
    raise ::GraphqlError::ArgumentError.new(message: 'amount must be more than 0') if amount <= 0

    nil
  end
end
