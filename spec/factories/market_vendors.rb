require 'faker'

FactoryBot.define do
  factory :market_vendor do
    association :market
    association :vendor
    market_id { market.id }
    vendor_id { vendor.id }
  end
end
