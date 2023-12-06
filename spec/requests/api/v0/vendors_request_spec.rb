require 'rails_helper'

describe 'Vendors API' do
  it 'gets a single vendor, by its id, show - /api/v0/vendors/:id' do
    vendor = create(:vendor)
    get "/api/v0/vendors/#{vendor.id}"
    expect(response).to be_successful

    vendor_parsed = JSON.parse(response.body, symbolize_names: true)

    attributes = vendor_parsed[:data][:attributes]

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

  it 'gets a single vendor, by its BAD id, show - /api/v0/vendors/:id, SAD path' do
    get "/api/v0/vendors/1"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
  end

  it "creates a new vendor, GOOD data 201 status,  create - /api/v0/vendors" do
    vendor_params = ({
                    name: 'Murder Stuffs',
                    description: 'Sppoky things',
                    contact_name: 'Sam T',
                    contact_phone: '1-800-522-1032',
                    credit_accepted: true
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    created_vendor = Vendor.last

    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it "creates a new vendor, MISSING name 400 status,  create - /api/v0/vendors, SAD PATH" do
    vendor_params = ({
                    description: 'Sppoky things',
                    contact_name: 'Sam T',
                    contact_phone: '1-800-522-1032',
                    credit_accepted: true
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    expect(response.status).to eq(400)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Name can't be blank")
  end

  it "creates a new vendor, MISSING description 400 status,  create - /api/v0/vendors, SAD PATH" do
    vendor_params = ({
                    name: 'Murder Stuff',
                    contact_name: 'Sam T',
                    contact_phone: '1-800-522-1032',
                    credit_accepted: true
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    expect(response.status).to eq(400)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Description can't be blank")
  end

  it "creates a new vendor, MISSING contact_name 400 status,  create - /api/v0/vendors, SAD PATH" do
    vendor_params = ({
                    name: 'Murder Stuff',
                    description: 'Spooky Things',
                    contact_phone: '1-800-522-1032',
                    credit_accepted: true
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    expect(response.status).to eq(400)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank")
  end

  it "creates a new vendor, MISSING contact_phone 400 status,  create - /api/v0/vendors, SAD PATH" do
    vendor_params = ({
                    name: 'Murder Stuff',
                    description: 'Spooky Things',
                    contact_name: 'Sam T',
                    credit_accepted: true
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    expect(response.status).to eq(400)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Contact phone can't be blank")
  end

  it "creates a new vendor, MISSING credit_accepted 400 status,  create - /api/v0/vendors, SAD PATH" do
    vendor_params = ({
                    name: 'Murder Stuff',
                    description: 'Spooky Things',
                    contact_name: 'Sam T',
                    contact_phone: '1-800-522-1032',
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    expect(response.status).to eq(400)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Credit accepted can't be blank")
  end

  it "can destroy an vendor, by id, successful 204 status, delete - /api/v0/vendors/:id" do
    vendor = create(:vendor)
    market = create(:market)
    market_vendor = create(:market_vendor, market: market, vendor: vendor)
  
    expect{ delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)
    expect(response.status).to eq(204)
    expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can destroy an vendor, by BAD id, 404 status, delete - /api/v0/vendors/:id, SAD path" do
    vendor = create(:vendor)
    market = create(:market)
    market_vendor = create(:market_vendor, market: market, vendor: vendor)
  
    expect{ delete "/api/v0/vendors/1" }.to change(Vendor, :count).by(0)
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
  end

end
