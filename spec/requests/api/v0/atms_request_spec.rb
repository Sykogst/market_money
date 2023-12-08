require 'rails_helper'

describe 'Nearest atms', type: :request do
  describe 'Get All atms near market' do
    it 'sends a list of all vendors for a market, GET /api/v0/markets/:id/nearest_atms' do
      market = create(:market)

      get "/api/v0/markets/#{market.id}/nearest_atms"
      # expect(response).to be_successful

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end