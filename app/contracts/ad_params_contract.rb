# frozen_string_literal: true

require 'dry/validation'

class AdParamsContract < Dry::Validation::Contract
  params do
    optional(:ad).hash do
      optional(:title).value(:string)
      optional(:description).value(:string)
      optional(:city).value(:string)
    end
  end

  # https://dry-rb.org/gems/dry-validation/1.8/rules/
  rule(:ad) do
    key.failure(I18n.t(:blank, scope: 'model.errors.ad', default: 'missing parameter')) unless key?

    if !key? || value[:title].blank?
      key(%i[ad
             title]).failure(I18n.t(:blank, scope: 'model.errors.ad.title',
                                            default: 'missing parameter'))
    end
    if !key? || value[:description].blank?
      key(%i[ad
             description]).failure(I18n.t(:blank, scope: 'model.errors.ad.description',
                                                  default: 'missing parameter'))
    end
    if !key? || value[:city].blank?
      key(%i[ad
             city]).failure(I18n.t(:blank, scope: 'model.errors.ad.city',
                                           default: 'missing parameter'))
    end
  end
end
