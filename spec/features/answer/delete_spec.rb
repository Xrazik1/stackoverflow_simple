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
      visit question_path(question)
    end

    context 'Author' do
      scenario 'deletes his answer', js: true do
        click_on 'Удалить'

        expect(page).to_not have_content answer.body
      end
    end
  end

  describe 'Unathenticated user' do
    scenario "cannot delete someone's answer" do
      visit question_path(question)

      expect(page).to_not have_button 'Удалить'
    end
  end

  describe 'Stranger' do
    given(:stranger) { create(:user) }

    scenario "cannot delete someone's answer", js: true do
      login(stranger)
      visit question_path(question)
      expect(page).to_not have_button 'Удалить'
    end
  end
end

