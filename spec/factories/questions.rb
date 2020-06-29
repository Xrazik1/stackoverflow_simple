FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body  { 'QuestionText' }
    user

    trait :invalid do
      title { nil }
    end
  end
end
