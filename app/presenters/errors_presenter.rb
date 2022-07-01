# frozen_string_literal: true

class ErrorsPresenter
  NESTED_ERROR_DELIMITER = '.'

  class << self
    def call(object)
      errors_in_hash_format = parse_errors(object)
      flatten_hash(errors_in_hash_format).each_with_object([]) do |(field, messages), errors|
        errors << { field: field, messages: messages }
      end
    end

    private

    def parse_errors(object)
      object.errors.messages.each_with_object({}) do |(complex_field, message), errors|
        field, nested_field = complex_field.to_s.split(NESTED_ERROR_DELIMITER)
        errors[field] = if nested_field
                          object.send(field).each_with_object({}).with_index do |(entity, relation_errors), index|
                            relation_errors[index] = parse_errors(entity) if entity.errors.any?
                          end
                        else
                          message
                        end
      end
    end

    def flatten_hash(hash)
      hash.each_with_object({}) do |(key, value), result|
        if value.is_a? Hash
          flatten_hash(value).map do |nested_key, nested_value|
            result["#{key}.#{nested_key}"] = nested_value
          end
        else
          result[key] = value
        end
      end
    end
  end
end
