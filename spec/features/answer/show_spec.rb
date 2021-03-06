require 'rails_helper'

feature 'User can read answers', "
  In order to create answer
  I'd like to be able to read answers
" do

  given!(:question) { create(:question) }
  given!(:answers)  { create_list(:answer, 3, question: question) }

  scenario 'user can see the list of answers' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end


