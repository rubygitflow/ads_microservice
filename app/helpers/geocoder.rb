# frozen_string_literal: true

module Geocoder
  include ApiErrors

  def geocodes
    geocodes = geocoder_service.geocodes(geocoder_param)
    raise AttributeError if geocodes.blank?

    geocodes
  end

  private

  def geocoder_service
    @geocoder_service ||= GeocoderService::Geocoder.new
  end

  def geocoder_param
    request.params['ad']['city']
  end
end
