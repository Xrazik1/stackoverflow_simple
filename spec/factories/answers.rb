FactoryBot.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
