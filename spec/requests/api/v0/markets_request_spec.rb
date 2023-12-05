require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of all markets, get all markets, index - /api/v0/markets' do
    market_1 = create(:market, vendors: [create(:vendor)])
    market_2 = create(:market, vendors: create_list(:vendor, 2))
    market_3 = create(:market)
    # markets_list = [market_1, market_2, market_3]

    get '/api/v0/markets'
    expect(response).to be_successful
    
    markets_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(markets_parsed[:data].count).to eq(3)

    markets_parsed[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market).to have_key(:type)
      expect(market[:type]).to be_an(String)
      expect(market[:type]).to eq('market')

      attributes = market[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_an(String)

      expect(attributes).to have_key(:street)
      expect(attributes[:street]).to be_an(String)

      expect(attributes).to have_key(:city)
      expect(attributes[:city]).to be_an(String)

      expect(attributes).to have_key(:county)
      expect(attributes[:county]).to be_an(String)

      expect(attributes).to have_key(:state)
      expect(attributes[:state]).to be_an(String)

      expect(attributes).to have_key(:zip)
      expect(attributes[:zip]).to be_an(String)

      expect(attributes).to have_key(:lat)
      expect(attributes[:lat]).to be_an(String)

      expect(attributes).to have_key(:lon)
      expect(attributes[:lon]).to be_an(String)

      expect(attributes).to have_key(:vendor_count)
      expect(attributes[:vendor_count]).to be_an(Integer)
    end
  end

  it 'gets a single market, by its id, show - /api/v0/markets/:id' do
    market = create(:market)
    get "/api/v0/markets/#{market.id}"
    expect(response).to be_successful

    # market_parsed = JSON.parse(response.body, symbolize_names: true)
  end
end
