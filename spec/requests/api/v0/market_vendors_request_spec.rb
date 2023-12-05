require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of all vendors for a market, get all vendors, index - /api/v0/markets/:id/vendors' do
    vendors = create_list(:vendor, 5)
    market = create(:market, vendors: vendors)
    vendors_2 = create_list(:vendor, 5)
    market_2 = create(:market, vendors: vendors_2)

    get "/api/v0/markets/#{market.id}/vendors"
    expect(response).to be_successful

    vendors_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(markets_parsed[:data].count).to eq(5)

    vendors_parsed.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_an(String)
      expect(vendor[:type]).to eq('vendor')

      attributes = vendor[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_an(String)
      
      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_an(String)

      expect(attributes).to have_key(:contact_name)
      expect(attributes[:contact_name]).to be_an(String)

      expect(attributes).to have_key(:contact_phone)
      expect(attributes[:contact_phone]).to be_an(String)

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_an(Boolean)
    end
  end
end