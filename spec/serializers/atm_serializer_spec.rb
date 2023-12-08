require 'rails_helper'

RSpec.describe AtmSerializer, type: :serializer do
  describe 'Serializing' do
    it 'serializes ATM data with correct keys and types' do
      atm_data = {
        results: [
          {
            poi: { name: 'ATM1' },
            address: { freeformAddress: '123 Main St' },
            position: { lat: 40.7128, lon: -74.0060 },
            dist: 1000
          },
          {
            poi: { name: 'ATM2' },
            address: { freeformAddress: '456 Oak St' },
            position: { lat: 34.0522, lon: -118.2437 },
            dist: 1500
          }
        ]
      }

      serialized_atms = AtmSerializer.format_atms(atm_data)[:data]

      serialized_atm = serialized_atms.first[:attributes]

      expect(serialized_atm).to have_key(:name)
      expect(serialized_atm[:name]).to be_a(String)

      expect(serialized_atm).to have_key(:address)
      expect(serialized_atm[:address]).to be_a(String)

      expect(serialized_atm).to have_key(:lat)
      expect(serialized_atm[:lat]).to be_a(Float)

      expect(serialized_atm).to have_key(:lon)
      expect(serialized_atm[:lon]).to be_a(Float)

      expect(serialized_atm).to have_key(:distance)
      expect(serialized_atm[:distance]).to be_a(Float)
      expect(serialized_atm[:distance]).to eq(1000/1609.34)
    end
  end
end