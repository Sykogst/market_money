require 'rails_helper'

describe 'Market Vendors API', type: :request do
  describe 'Get All Vendors for a Market' do
    it 'sends a list of all vendors for a market, get all vendors, index - /api/v0/markets/:id/vendors' do
      vendors = create_list(:vendor, 5)
      market = create(:market)
      vendors.each do |vendor|
        create(:market_vendor, market: market, vendor: vendor)
      end
      # market = create(:market, vendors: vendors)
      vendors_2 = create_list(:vendor, 5)
      market_2 = create(:market)
      # market_2 = create(:market, vendors: vendors_2)
      vendors_2.each do |vendor|
        create(:market_vendor, market: market_2, vendor: vendor)
      end

      get "/api/v0/markets/#{market.id}/vendors"
      expect(response).to be_successful

      vendors_parsed = JSON.parse(response.body, symbolize_names: true)
      vendor_data = vendors_parsed[:data]
      expect(vendor_data.count).to eq(5)

      vendor_data.each do |vendor|
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
        expect(attributes[:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
      end
    end

    it 'gets a single market vendors, by its BAD id, index - /api/v0/markets/:id/vendors, SAD path' do
      get "/api/v0/markets/1/vendors"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=1")
    end
  end

  describe 'Create a MarketVendor' do
    it 'creates new market and a vendor association, GOOD data, 201 status, create /api/v0/market_vendors' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      created_market_vendor = MarketVendor.last

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_market_vendor.market_id).to eq(market_vendor_params[:market_id])
      expect(created_market_vendor.vendor_id).to eq(market_vendor_params[:vendor_id])
    end

    it 'after market_vendor creation, vendor is included when requesting get "/api/v0/markets/:id/vendors"' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      get "/api/v0/markets/#{market.id}/vendors"
      vendors_parsed = JSON.parse(response.body, symbolize_names: true)
      recent_vendor_data = vendors_parsed[:data].last

      expect(recent_vendor_data[:relationships][:markets][:data].last[:id].to_i).to eq(market.id)

      # Another vendor added to same market
      vendor_2 = create(:vendor)
      market_vendor_2_params = ({
        market_id: market.id,
        vendor_id: vendor_2.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_2_params)
      get "/api/v0/markets/#{market.id}/vendors"
      more_vendors_parsed = JSON.parse(response.body, symbolize_names: true)
      more_recent_vendor_data = more_vendors_parsed[:data].last

      expect(more_recent_vendor_data[:relationships][:markets][:data].last[:id].to_i).to eq(market.id)
    end

    # QUESTION Having trouble, they all either pass in as 400 or 404
    it 'creates new market and a vendor association, BAD market_id data, 404 status, create /api/v0/market_vendors' do
      vendor = create(:vendor)
      market_vendor_params = ({
        market_id: 1,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Validation failed: Market must exist")
    end

    it 'creates new market and a vendor association, BAD vendor_id data, 404 status, create /api/v0/market_vendors' do
      market = create(:market)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: 1
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Validation failed: Vendor must exist")
    end

    it 'creates new market and a vendor association, BAD nil market_id data, 400 status, create /api/v0/market_vendors' do
      vendor = create(:vendor)
      market_vendor_params = ({
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Validation failed: Market must exist, Market can't be blank")
    end

    it 'creates new market and a vendor association, BAD nil vendor_id data, 400 status, create /api/v0/market_vendors' do
      market = create(:market)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: nil
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Validation failed: Vendor must exist, Vendor can't be blank")
    end

    it 'creates new market and a vendor association, duplicate id data, 422 status, create /api/v0/market_vendors' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("422")
      expect(data[:errors].first[:title]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end

  describe 'Delete a MarketVendor' do
    xit 'creates new market and a vendor association, GOOD data, 201 status, DELETE /api/v0/market_vendors' do
      market = create(:market)
      vendor = create(:vendor)
      create(:market_vendor, market: market, vendor: vendor)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(MarketVendor.count).to eq(0)
    end
  end
end