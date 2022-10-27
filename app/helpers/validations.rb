# frozen_string_literal: true

module Validations
  include ApiErrors

  def validate_with!(validation)
    result = validate_with(validation)
    raise MissingParams, result.errors.to_hash if result.errors.present?

    result
  end

  def validate_with(validation)
    contract = validation.new
    # https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/TypecastParams.html
    contract.call(request.params)
  end
end
