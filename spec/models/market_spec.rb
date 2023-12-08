require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'Validations and Relationships' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }

    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe '#Instance Methods' do
    it '#get_vendor_count' do
      market = create(:market)
      expect(market.get_vendor_count).to eq(0)

      vendor = create(:vendor)
      market.vendors << vendor
      expect(market.get_vendor_count).to eq(1)

      more_vendors = create_list(:vendor, 2)
      market.vendors << more_vendors
      expect(market.get_vendor_count).to eq(3)
    end
  end

  describe '.Class methods' do
    it '.search' do
      market1 = create(:market, state: 'California', city: 'Los Angeles', name: 'Downtown Market')
      market2 = create(:market, state: 'California', city: 'San Francisco', name: 'Bay Area Market')
      market3 = create(:market, state: 'New York', city: 'New York City', name: 'Big Apple Market')
      results = Market.search('California', nil, 'Market')

      expect(results).to include(market1, market2)
      expect(results).not_to include(market3)
    end

    it 'is case-insensitive' do
      market = create(:market, state: 'California', city: 'Los Angeles', name: 'Downtown Market')
      results = Market.search('california', 'los angeles', 'downtown market')

      expect(results).to include(market)
    end

    it 'returns an empty array if no matches are found' do
      results = Market.search('Texas', 'Houston', 'Nonexistent Market')

      expect(results).to be_empty
    end
  end
end
