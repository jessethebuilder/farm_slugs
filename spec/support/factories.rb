FactoryGirl.define do
  factory :farm_slug_object do
    name { Faker::Name.name }
  end
  
  factory :farm_slug_object_alt do
    title { Faker::Name.name }
  end
end