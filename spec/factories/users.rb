FactoryBot.define do
  factory :user do
    nickname { Faker::Internet.username }
  end
end
