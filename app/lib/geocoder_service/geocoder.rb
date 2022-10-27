# frozen_string_literal: true

# frozen_string_literal: true

require 'dry/initializer'
require_relative 'api'

module GeocoderService
  class Geocoder
    extend Dry::Initializer[undefined: false]
    include Api

    option :url, default: proc { ENV.fetch('GEOCODER_URL', 'http://localhost:3002') }
    option :connection, default: proc { build_connection }

    private

    def build_connection
      Faraday.new(@url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
