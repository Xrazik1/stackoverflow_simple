FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '123456' }
    password_confirmation { '123456' }

    factory :user_with_questions do
      transient do
        questions_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user_id: user.id)
      end
    end

    factory :user_with_answers do
      transient do
        answers_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:answer, evaluator.answers_count, user_id: user.id)
      end
    end
  end
end
