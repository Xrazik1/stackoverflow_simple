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

    factory :question_with_files do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
    end
  end
end
