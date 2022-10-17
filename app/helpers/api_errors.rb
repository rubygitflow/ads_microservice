# frozen_string_literal: true

module ApiErrors
  def error_response(error_messages, meta: {})
    case error_messages
    when Sequel::Model
      ErrorSerializer.from_model(error_messages)
    when Hash
      ErrorSerializer.from_hash(error_messages)
    else
      ErrorSerializer.from_messages(error_messages, meta: meta)
    end
  end

  class MissingParams < StandardError
    attr_reader :errors

    def initialize(error = {})
      @errors = error
      message = I18n.t(:missing_parameters, scope: 'api.errors')

      super(message)
    end
  end
end
