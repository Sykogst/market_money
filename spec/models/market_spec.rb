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

  describe 'Callback Methods' do
    it '#get_vendor_count' do
      market = create(:market)
      expect(market.send(:get_vendor_count)).to eq(0)
      vendor = create(:vendor)
      market.vendors << vendor
      # QUESTION: I tried and did not work... create_list(:vendor, 3, markets: market)
      expect(market.send(:get_vendor_count)).to eq(1)

      more_vendors = create_list(:vendor, 2)
      market.vendors << more_vendors
      # QUESTION: What exactly invokes before_save
      market.save 

      expect(market.vendor_count).to eq(3)
    end
  end
end
