# frozen_string_literal: true

class BaseAction
  def initialize(rails_controller)
    @rails_controller = rails_controller
  end

  def call
    process
    self
  end

  def success?
    !failure?
  end

  def failure?
    errors_status.present?
  end

  def success
    {
      messages: success_messages.presence || ['OK'],
      data: success_data,
      status: success_status || :ok
    }
  end

  def errors
    {
      messages: errors_messages.presence || ['Unknown error'],
      data: errors_data,
      status: errors_status || :unprocessable_entity
    }
  end

  private

  attr_reader :rails_controller, :errors_status, :success_status
  delegate(:params, to: :rails_controller, private: true)

  def process
    raise NotImplementedError
  end

  def success_messages
    @success_messages ||= []
  end

  def success_data
    @success_data ||= {}
  end

  def errors_messages
    @errors_messages ||= []
  end

  def errors_data
    @errors_data ||= {}
  end

  def success_with(messages: nil, data: {}, status: :ok)
    success_messages.concat(Array(messages))
    success_data.merge!(data) if data.is_a?(Hash)
    @success_status = status
  end

  def fail_with(messages:, data: {}, status: :unprocessable_entity)
    errors_messages.concat(Array(messages))
    errors_data.merge!(data) if data.is_a?(Hash)
    @errors_status = status
  end

  def fail_with_validation(errors_or_object)
    if errors_or_object.is_a?(Hash)
      errors = errors_or_object
    else
      errors = ::ErrorsPresenter.call(errors_or_object)
      model_name = errors_or_object.class.name
    end

    fail_with(messages: 'Validation error', data: { validations: errors, validation_model: model_name })
  end
end
