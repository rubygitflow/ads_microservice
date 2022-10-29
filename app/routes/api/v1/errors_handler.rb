# frozen_string_literal: true

class AdsMicroservice
  include ApiErrors

  plugin :error_handler do |e|
    case e
    when Auth::Unauthorized
      response.status = 403
      error_response I18n.t(:unauthorized, scope: 'api.errors')
    # https://www.rubydoc.info/gems/sequel/4.8.0/Sequel
    # https://sequel.jeremyevans.net/rdoc/
    when Sequel::NoMatchingRow
      response.status = 404
      error_response e.message, meta: { 'meta' => I18n.t(:not_found, scope: 'api.errors') }
    when Sequel::UniqueConstraintViolation
      response.status = 422
      error_response e.message, meta: { 'meta' => I18n.t(:not_unique, scope: 'api.errors') }
    # https://www.rubydoc.info/gems/roda/Roda/RodaPlugins/TypecastParams
    when Roda::RodaPlugins::TypecastParams::Error
      response.status = 422
      error_response e.message, meta: { 'meta' => I18n.t(:missing_parameters, scope: 'api.errors') }
    when KeyError
      response.status = 422
      error_response e.message, meta: { 'meta' => I18n.t(:missing_parameters, scope: 'api.errors') }
    when AttributeError # Dry::Validation::Result
      response.status = 422
      error_response e.message
    when MissingParams # Dry::Validation::Result
      response.status = 422
      error_response(e.errors)
    else
      logger.fatal(
        'Unknown fatal error',
        error: e.message,
        class: e.class.name,
        trace: e.backtrace
      )
      response.status = 500
      error_response e.message, meta: { 'meta' => e.class }
    end
  end
end
