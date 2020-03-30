require 'rails_helper'

feature 'User can delete question', "
  In order to ask a question
  As an authenticated user
  I'd like to be able to delete the question
" do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user' do
    background { login(user) }

    describe 'Author' do
      scenario 'deletes the question' do
        click_on 'Удалить'

        expect(page).to have_content 'Вопрос успешно удалён'
        expect(page).to_not have_content 'Test question'
      end
    end

    context 'Stranger' do
      given(:another_user) { create(:user) }

      background do
        click_on 'Выйти'
        login(another_user)
      end

      scenario "cannot delete someone's question" do
        visit questions_path
        expect(page).to_not have_button 'Удалить'
      end
    end
  end

  describe 'Unathenticated user' do
    scenario "cannot delete someone's question" do
      visit questions_path
      expect(page).to_not have_button 'Удалить'
    end
  end
end

