FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    price { 1000 }
    description { "This is a sample product." }

    after(:create) do |product|
      product.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/test_image.png")),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end