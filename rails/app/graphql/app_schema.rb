# frozen_string_literal: true

class AppSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  rescue_from(ActiveRecord::RecordNotFound) do |err, _obj, _args, _ctx, _field|
    Rails.logger.error err
    raise GraphqlError::ServerError
  end

  rescue_from(ActiveRecord::RecordInvalid) do |err, _obj, _args, _ctx, _field|
    Rails.logger.error err
    raise GraphqlError::ServerError
  end

  rescue_from(StandardError) do |err, _obj, _args, _ctx, _field|
    Rails.logger.error err
    raise GraphqlError::ServerError
  end

  # Opt in to the new runtime (default in future graphql-ruby versions)
  # use GraphQL::Execution::Interpreter
  # use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  # use GraphQL::Pagination::Connections
  use GraphQL::Batch
end
