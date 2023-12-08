class Market < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :vendors, through: :market_vendors
  
  validates :name, :street, :city, :county, :state, :zip, :lat, :lon, presence: true

  def get_vendor_count
    self.vendors.count
  end

  def self.search(state, city, name)
    # results = all

    # results = results.where('LOWER(state) = ?', state.downcase) if state.present?
    # results = results.where(city: city) if city.present?
    # results = results.where('LOWER(name) LIKE ?', "%#{name.downcase}%") if name.present?
  
    # results

        results = results.where('LOWER(state) = ?', state.downcase) if state.present?
    results = results.where(city: city) if city.present?
    results = results.where('LOWER(name) LIKE ?', "%#{name.downcase}%") if name.present?
  end
end
