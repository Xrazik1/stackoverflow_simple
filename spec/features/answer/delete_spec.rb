require 'rails_helper'

feature 'User can delete answer', "
  In order to create answer
  As an authenticated user
  I'd like to be able to delete it
" do

  given(:user) { create(:user) }

  background do
    visit questions_path
    click_on 'Войти'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    fill_in 'question[title]', with: 'Test question'
    fill_in 'question[body]', with: 'Question text'
    click_on 'Создать'

    click_on 'Открыть'
  end

  describe 'Authenticated user' do
    scenario 'deletes an answer' do
      fill_in 'answer[body]', with: 'Answer text'
      click_on 'Создать'
      click_on 'Удалить'

      expect(page).to have_content 'Ответ успешно удалён'
      expect(page).to_not have_content 'Answer text'
    end
  end

  describe 'Unathenticated user' do
    scenario "cannot delete someone's answer" do
      fill_in 'answer[body]', with: 'Answer text'
      click_on 'Создать'

      click_on 'Выйти'
      visit questions_path
      click_on 'Открыть'

      expect(page).to_not have_content 'Удалить'
    end
  end
end

