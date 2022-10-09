# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    # https://dry-rb.org/gems/dry-initializer/3.0/type-constraints/
    option :ad, {} do
      option :title,        proc(&:to_s)
      option :description,  proc(&:to_s)
      option :city,         proc(&:to_s)
      option :user_id,      proc(&:to_i)
    end

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)

      if @ad.valid?
        @ad.save
      else
        fail!(@ad.errors)
      end
    end
  end
end
