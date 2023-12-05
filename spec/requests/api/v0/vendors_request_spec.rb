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
    created_book = Vendor.last
  
    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(created_book.name).to eq(vendor_params[:name])
    expect(created_book.description).to eq(vendor_params[:description])
    expect(created_book.contact_name).to eq(vendor_params[:contact_name])
    expect(created_book.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_book.credit_accepted).to eq(vendor_params[:credit_accepted])
  end
end
