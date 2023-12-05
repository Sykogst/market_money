require 'rails_helper'

RSpec.describe MarketSerializer, type: :request do
  describe 'Serializing' do
    it 'has keys and data with types' do
      create_list(:market, 5)
      get '/api/v0/markets'
      expect(response).to be_successful

      data = JSON.parse(response.body)
      market = data["data"].first["attributes"]

      expect(market).to have_key("name")
      expect(market["name"]).to be_an(String)

      expect(market).to have_key("street")
      expect(market["street"]).to be_an(String)

      expect(market).to have_key("city")
      expect(market["city"]).to be_an(String)

      expect(market).to have_key("county")
      expect(market["county"]).to be_an(String)

      expect(market).to have_key("state")
      expect(market["state"]).to be_an(String)

      expect(market).to have_key("zip")
      expect(market["zip"]).to be_an(String)

      expect(market).to have_key("lat")
      expect(market["lat"]).to be_an(String)

      expect(market).to have_key("lon")
      expect(market["lon"]).to be_an(String)

      expect(market).to have_key("vendor_count")
      expect(market["vendor_count"]).to be_an(Integer)
    end
  end
end