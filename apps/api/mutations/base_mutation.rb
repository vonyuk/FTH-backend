# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    INVALID_RESOURCE = 'INVALID_RESOURCE'

    def raise_invalid_resource(resource_name, errors)
      raise GraphQL::ExecutionError.new(
        I18n.t(
          'errors.messages.invalid_resource',
          resource_name: resource_name
        ),
        extensions: {
          code: INVALID_RESOURCE,
          problems: format_errors(errors)
        }.transform_keys!(&:to_s)
      )
    end

    private

    def format_errors(errors)
      errors.map do |error|
        default_format(error.keys.first, error.values.first)
      end
    end

    def default_format(attribute, value)
      {
        path: [attribute.to_s],
        explanation: "\"#{value[:value]}\" #{value[:message].join(', ')}",
        message: "\"#{value[:value]}\" #{value[:message].join(', ')}"
      }.transform_keys!(&:to_s)
    end
  end
end
