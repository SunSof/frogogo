FactoryBot.define do
  factory :cart do
    status { :pending }
    discount { 0 }
  end
end