require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of markets' do
    create_list(:market, 3)

    get '/api/v0/markets'
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    expect(markets.count).to eq(3)
  end
end