require 'rails_helper'

RSpec.describe VendorSerializer, type: :request do
  describe 'Serializing' do
    it 'has keys and data with types' do
      vendors = create_list(:vendor, 5)
      market = create(:market, vendors: vendors)
      get "/api/v0/markets/#{market.id}/vendors"
      expect(response).to be_successful

      data = JSON.parse(response.body)
      vendor = data["data"].first["attributes"]

      expect(vendor).to have_key("name")
      expect(vendor["name"]).to be_an(String)

      expect(vendor).to have_key("description")
      expect(vendor["description"]).to be_an(String)

      expect(vendor).to have_key("contact_name")
      expect(vendor["contact_name"]).to be_an(String)

      expect(vendor).to have_key("contact_phone")
      expect(vendor["contact_phone"]).to be_an(String)

      expect(vendor).to have_key("credit_accepted")
      expect(vendor["credit_accepted"]).to be_a(TrueClass).or be_a(FalseClass)
    end
  end
end