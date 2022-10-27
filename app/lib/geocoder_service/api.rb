# frozen_string_literal: true

module GeocoderService
  module Api
    def geocodes(city)
      response = connection.get('') do |req|
        req.params['city'] = city
      end

      response.body.fetch('data', {}) if response.success?
    end
  end
end
