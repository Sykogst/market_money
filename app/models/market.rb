class Market < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :vendors, through: :market_vendors
  
  validates :name, :street, :city, :county, :state, :zip, :lat, :lon, presence: true

  before_save do |market| 
    market.vendor_count = get_vendor_count
  end

  private

  def get_vendor_count
    self.vendors.count
  end
end
