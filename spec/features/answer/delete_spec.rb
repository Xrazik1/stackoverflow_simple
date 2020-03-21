require 'rails_helper'

feature 'User can delete answer', "
  In order to create answer
  As an authenticated user
  I'd like to be able to delete it
" do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_answers_path(question)
    end

    scenario 'deletes an answer' do
      click_on 'Удалить'

      expect(page).to have_content 'Ответ успешно удалён'
      expect(page).to_not have_content answer.body
    end
  end

  describe 'Unathenticated user' do
    scenario "cannot delete someone's answer" do
      visit question_answers_path(question)

      expect(page).to_not have_content 'Удалить'
    end
  end
end

