# frozen_string_literal: true

RSpec.describe AdsMicroservice, type: :routes do
  describe 'GET /api/v1/ads' do
    let(:user_id) { 101 }

    before do
      create_list(:ad, 3, user_id: user_id)
    end

    it 'returns a collection of ads' do
      get '/api/v1/ads'

      expect(response_body['data'].size).to eq(3)
    end

    it 'has status 200' do
      get '/api/v1/ads'

      expect(last_response.status).to eq(200)
    end
  end

  describe 'POST /api/v1/ads' do
    let(:user_id) { 101 }

    context 'with missing parameters' do
      it 'returns an error' do
        post '/api/v1/ads'

        expect(last_response.status).to eq(422)
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

      it 'has status 422' do
        post '/api/v1/ads', ad: ad_params

        expect(last_response.status).to eq(422)
      end

      it 'returns an error' do
        post '/api/v1/ads', ad: ad_params

        expect(response_body['errors']).to include(
          {
            'detail' => 'Add a city',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end

    context 'with valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City',
          user_id: user_id
        }
      end

      let(:last_ad) { Ad.last }

      it 'creates a new ad' do
        expect { post '/api/v1/ads', ad: ad_params }
          .to change { Ad.count }.from(0).to(1)
      end

      it 'has status 201' do
      	post '/api/v1/ads', ad: ad_params

        expect(last_response.status).to eq(201)
      end

      it 'returns an ad' do
        post '/api/v1/ads', ad: ad_params

        expect(response_body['data']).to a_hash_including(
          'id' => last_ad.id,
          "city" => "City"
        )
      end
    end
  end
end
