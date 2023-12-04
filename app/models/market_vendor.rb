class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market, :vendor, presence: true
end
