require 'rails_helper'

feature 'User can delete question', "
  In order to ask a question
  As an authenticated user
  I'd like to be able to delete the question
" do

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      visit questions_path
      click_on 'Войти'

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    scenario 'deletes the question' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'Question text'
      click_on 'Создать'
      click_on 'Удалить'

      expect(page).to have_content 'Вопрос успешно удалён'
      expect(page).to_not have_content 'Test question'
    end

    scenario "cannot delete someone's question" do
      create(:question)
      visit questions_path
      expect(page).to_not have_content 'Удалить'
    end
  end

  describe 'Unathenticated user' do
    scenario "cannot delete someone's question" do
      create(:question)
      visit questions_path
      expect(page).to_not have_content 'Удалить'
    end
  end
end

