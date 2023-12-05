class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon

  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  attribute :vendor_count do |object|
    object.get_vendor_count
  end

  # def self.format_markets(markets)
  #   {
  #     data: markets.map do |market|
  #       {
  #         id: market.id,
  #         type: 'market',
  #         attributes: {
  #           name: market.name,
  #           street: market.street,
  #           city: market.city,
  #           county: market.county,
  #           state: market.state,
  #           zip: market.zip,
  #           lat: market.lat,
  #           lon: market.lon,
  #           vendor_count: market.get_vendor_count
  #         }
          # relationships: {
            # market.vendors...
          # }
  #       }
  #     end
  #   }
  # end
end