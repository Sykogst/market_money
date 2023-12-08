require 'rails_helper'

RSpec.describe 'Search by name, city, state', type: :request do
  describe 'get /api/v0/markets/search' do
    it 'returns a successful response, 200, with markets data' do
      market = create(:market, state: 'Colorado', city: 'Denver', name: 'Farmers Market')
      market_2 = create(:market, state: 'California', city: 'Denver', name: 'Farmers Market')

      market_search_params = {
        state: 'colorado'
      }

      get '/api/v0/markets/search', params: market_search_params

      expect(response.status).to eq(200)
      expect(response.body).to include(market.id.to_s)
      expect(response.body).to include(market.name)
      expect(response.body).to_not include(market_2.id.to_s)
    end

    it 'returns a successful response, 200, with markets data, when nothing is returned' do
      market = create(:market, state: 'Colorado', city: 'Denver', name: 'Farmers Market')
      market_2 = create(:market, state: 'California', city: 'Denver', name: 'Farmers Market')

      market_search_params = {
        state: "Arizona"
      }

      get '/api/v0/markets/search', params: market_search_params
      data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(data[:data]).to eq([])
    end

    it 'returns an error response with 422 status, invalid param combination 1' do
      market = create(:market, state: 'Colorado', city: 'Denver', name: 'Farmers Market')
      market_search_params = {
        city: market.city
      }

      get '/api/v0/markets/search', params: market_search_params
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('422')
      expect(data[:errors].first[:title]).to eq("Invalid params combination, needs state included, or just name")
    end

    it 'returns an error response with 422 status, invalid param combination 2' do
      market = create(:market, state: 'Colorado', city: 'Denver', name: 'Farmers Market')
      market_search_params = {
        city: market.city,
        name: market.name
      }

      get '/api/v0/markets/search', params: market_search_params
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('422')
      expect(data[:errors].first[:title]).to eq("Invalid params combination, needs state included, or just name")
    end
  end
end