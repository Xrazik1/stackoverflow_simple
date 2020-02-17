FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    answers { [] }

    trait :invalid do
      title { nil }
    end
  end
end
