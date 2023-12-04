FactoryBot.define do
  factory :market do
    name { Faker::Lorem.word }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.county }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end