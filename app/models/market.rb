class Market < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :vendors, through: :market_vendors
  
  validates :name, :street, :city, :county, :state, :zip, :lat, :lon, presence: true

  def get_vendor_count
    self.vendors.count
  end

  def self.search(state, city, name)
    Market.where("markets.city ILIKE '%#{city}%' and markets.state ILIKE '%#{state}%' and markets.name ilike '%#{name}%'")
  end
end
