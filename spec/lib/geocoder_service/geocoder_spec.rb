# frozen_string_literal: true

RSpec.describe GeocoderService::Geocoder, type: :client do
  subject(:geocoder) { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.get('') { [status, headers, body.to_json] }
  end

  describe '# (valid param)' do
    let(:coords) { { 'lat' => 1.1, 'lon' => 2.2 } }
    let(:body) { { 'data' => coords } }

    it 'returns city coords' do
      expect(geocoder.geocodes('valid.param')).to eq(coords)
    end
  end

  describe '# (invalid param)' do
    let(:status) { 422 }

    it 'returns a nil value' do
      expect(geocoder.geocodes('invalid.param')).to be_nil
    end
  end

  describe '# (nil param)' do
    let(:status) { 422 }

    it 'returns a nil value' do
      expect(geocoder.geocodes(nil)).to be_nil
    end
  end
end
