class MarketSerializer
  def self.format_markets(markets)
    {
      data: markets.map do |market|
        {
          id: market.id,
          type: 'market',
          attributes: {
            name: market.name,
            street: market.street,
            city: market.city,
            county: market.county,
            state: market.state,
            zip: market.zip,
            lat: market.lat,
            lon: market.lon,
            vendor_count: market.get_vendor_count
          }
        }
      end
    }
  end
end