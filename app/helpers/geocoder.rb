# frozen_string_literal: true

module Geocoder
  include ApiErrors

  CITY_PARAM = /\A(?<city>.+)\z/.freeze

  def geocodes
    geocodes = geocoder_service.geocodes(matched_param)
    raise AttributeError if geocodes.blank?

    geocodes
  end

  private

  def geocoder_service
    @geocoder_service ||= GeocoderService::Geocoder.new
  end

  def matched_param
    result = geocoder_param&.match(CITY_PARAM)
    return if result.blank?

    result[:city]
  end

  def geocoder_param
    request.params['ad']['city']
  end
end
