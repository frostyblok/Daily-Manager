FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email 'frosty#gmail.com'
    password_digest 'surprise'
  end
end