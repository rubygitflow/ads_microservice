# frozen_string_literal: true

RSpec.describe Ads::CreateService do
  subject(:ad) { described_class }

  let(:user_id) { 102 }
  let(:geocodes) { { 'lat' => 1.1, 'lon' => 2.2 } }

  context 'with valid parameters' do
    let(:ad_params) do
      {
        title: 'Ad title',
        description: 'Ad description',
        city: 'City'
      }
    end

    it 'creates a new ad' do
      expect { ad.call(ad: ad_params, user_id: user_id, geocodes: geocodes) }
        .to change(Ad, :count).from(0).to(1)
    end

    it 'assigns ad' do
      result = ad.call(ad: ad_params, user_id: user_id, geocodes: geocodes)

      expect(result.ad).to be_kind_of(Ad)
    end
  end

  context 'with invalid parameters' do
    let(:ad_params) do
      {
        title: 'Ad title',
        description: 'Ad description',
        city: ''
      }
    end

    it 'does not create ad' do
      expect { ad.call(ad: ad_params, user_id: user_id, geocodes: geocodes) }
        .not_to change(Ad, :count)
    end

    it 'assigns ad' do
      result = ad.call(ad: ad_params, user_id: user_id, geocodes: geocodes)

      expect(result.ad).to be_kind_of(Ad)
    end
  end
end
