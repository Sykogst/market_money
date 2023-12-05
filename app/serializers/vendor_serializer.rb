class VendorSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :contact_name, :contact_phone

  has_many :market_vendors
  has_many :markets, through: :market_vendors
end
