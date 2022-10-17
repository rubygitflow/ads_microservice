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

    option :geocodes, {} do
      option :lat,          proc(&:to_s)
      option :lon,          proc(&:to_s)
    end

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      @ad.user_id = @user_id
      @ad.lat = @geocodes.to_h.fetch('lat')
      @ad.lon = @geocodes.to_h.fetch('lon')

      if @ad.valid?
        @ad.save
      else
        fail!(@ad.errors)
      end
    end
  end
end
