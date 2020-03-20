require 'rails_helper'

feature 'User can read answers', "
  In order to create answer
  I'd like to be able to read answers
" do

  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }

  scenario 'user can see the list of answers' do
    visit question_answers_path(question)

    expect(page).to have_content answer.body
  end
end


