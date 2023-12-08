require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'Validations, and Relationships' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
  
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe '#credit_accepted_presence' do
    it 'when credit_accepted is niladds an error to the model' do
      # build sets up without saving to database
      vendor = build(:vendor, credit_accepted: nil) 
      vendor.valid?
      expect(vendor.errors[:credit_accepted]).to include("can't be blank")
    end

    it 'when credit_accepted is not nil, does not add an error to the model' do
      vendor = build(:vendor, credit_accepted: true)
      vendor.valid?
      expect(vendor.errors[:credit_accepted]).to be_empty
    end
  end
end
