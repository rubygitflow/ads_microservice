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
    let(:auth_token) { 'auth.token' }
    let(:auth_service) { instance_double('Auth service') }
    let(:coords) { { 'lat' => 1.1, 'lon' => 2.2 } }
    let(:geocoder_service) { instance_double('Geocoder service') }
    let(:ad) { create(:ad) }

    before do
      allow(auth_service).to receive(:auth)
        .with(auth_token)
        .and_return(user_id)

      allow(AuthService::Client).to receive(:new).and_return(auth_service)

      header 'Authorization', "Bearer #{auth_token}"

      allow(geocoder_service).to receive(:geocode_later)
        .with(ad)
    end

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
          city: ''
        }
      end

      it 'has status 422' do
        post '/api/v1/ads', ad: ad_params

        expect(last_response.status).to eq(422)
      end

      it 'returns an error' do
        post '/api/v1/ads', ad: ad_params

        expect(response_body['errors']).to eq(
          [
            {
              'detail' => {
                'city' => ['Add a city']
              },
              'source' => {
                'pointer' => '/data/attributes/ad'
              }
            }
          ]
        )
      end
    end

    context 'with missing user_id' do
      let(:user_id) { nil }

      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City'
        }
      end

      it 'has status 403' do
        post '/api/v1/ads', ad: ad_params

        expect(last_response.status).to eq(403)
      end

      it 'returns an error' do
        post '/api/v1/ads', ad: ad_params

        expect(response_body['errors']).to include('detail' => 'Access to the resource is limited')
      end
    end

    context 'with valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City'
        }
      end

      let(:last_ad) { Ad.last }

      it 'creates a new ad' do
        expect { post '/api/v1/ads', ad: ad_params }
          .to change(Ad, :count).from(1).to(2)
      end

      it 'has status 201' do
        post '/api/v1/ads', ad: ad_params

        expect(last_response.status).to eq(201)
      end

      it 'returns an ad' do
        post '/api/v1/ads', ad: ad_params

        expect(response_body['data']).to a_hash_including(
          'id' => last_ad.id,
          'city' => 'City'
        )
      end
    end
  end
end
