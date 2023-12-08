class AtmSerializer
  def self.format_atms(atms)
    {
      data: atms.map do |result|
        {
          id: nil,
          type: 'atm',
          attributes: {
            name: result[:poi][:name],
            address: result[:address][:freeformAddress],
            lat: result[:position][:lat],
            lon: result[:position][:lon],
            distance: result[:dist] / 1609.34
          }
        }
      end
    }
  end
end