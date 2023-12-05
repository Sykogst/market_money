require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of all markets' do
      market_1 = create(:market, vendors: [create(:vendor)])
      market_2 = create(:market, vendors: create_list(:vendor, 2))
      market_3 = create(:market)
      markets = [market_1, market_2, market_3]
      # QUESTION For some reason, I had to force save in this test
      # Would this mean it is not working otherwise after an API request?
      markets.each { |market| market.save }

    get '/api/v0/markets'
    expect(response).to be_successful
    markets = JSON.parse(response.body, symbolize_names: true)
    expect(markets[:data].count).to eq(3)

    markets[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

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
end