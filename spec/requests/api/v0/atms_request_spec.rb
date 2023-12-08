require 'rails_helper'

describe 'Nearest atms', type: :request do
  describe 'Get All atms near market' do
    it 'sends a list of atms near market, GET /api/v0/markets/:id/nearest_atms' do
      market = create(:market)

      get "/api/v0/markets/#{market.id}/nearest_atms"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data).to have_key(:data)
      expect(response_data[:data]).to be_an(Array)

      atm = response_data[:data].first
      expect(atm).to have_key(:id)
      expect(atm).to have_key(:type)
      expect(atm).to have_key(:attributes)

      atm_attributes = atm[:attributes]
      expect(atm_attributes).to have_key(:name)
      expect(atm_attributes).to have_key(:address)
      expect(atm_attributes).to have_key(:lat)
      expect(atm_attributes).to have_key(:lon)
      expect(atm_attributes).to have_key(:distance)
    end

    it 'BAD market id, 404 error, GET /api/v0/markets/:id/nearest_atms' do
      get "/api/v0/markets/1/nearest_atms"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      response_data = JSON.parse(response.body, symbolize_names: true)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=1")
    end
  end
end