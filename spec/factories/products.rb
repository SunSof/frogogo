FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    price { 1000 }
    description { "This is a sample product." }
  end
end