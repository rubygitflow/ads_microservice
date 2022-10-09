# frozen_string_literal: true

RSpec.describe Ads::CreateService do
  subject(:ad) { described_class }

  let(:user_id) { 102 }

  context 'with valid parameters' do
    let(:ad_params) do
      {
        title: 'Ad title',
        description: 'Ad description',
        city: 'City',
        user_id: user_id
      }
    end

    it 'creates a new ad' do
      expect { ad.call(ad: ad_params) }
        .to change(Ad, :count).from(0).to(1)
    end

    it 'assigns ad' do
      result = ad.call(ad: ad_params)

      expect(result.ad).to be_kind_of(Ad)
    end
  end

  context 'with invalid parameters' do
    let(:ad_params) do
      {
        title: 'Ad title',
        description: 'Ad description',
        city: '',
        user_id: user_id
      }
    end

    it 'does not create ad' do
      expect { ad.call(ad: ad_params) }
        .not_to change(Ad, :count)
    end

    it 'assigns ad' do
      result = ad.call(ad: ad_params)

      expect(result.ad).to be_kind_of(Ad)
    end
  end
end
