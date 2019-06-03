FactoryBot.define do
  factory :user do
    name { Faker::Name.name}
    email { 'frosty@gmail.com' }
    password { 'surprise' }
  end
end
