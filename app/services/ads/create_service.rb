# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    # https://dry-rb.org/gems/dry-initializer/3.0/type-constraints/
    option :ad, {} do
      option :title,        proc(&:to_s)
      option :description,  proc(&:to_s)
      option :city,         proc(&:to_s)
    end

    option :user_id, proc(&:to_i)

    option :geocoder_service, default: proc { GeocoderService::Client.new }

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      @ad.user_id = @user_id

      if @ad.valid?
        @ad.save
        @geocoder_service.geocode_later(@ad)
      else
        fail!(@ad.errors)
      end
    end
  end
end
