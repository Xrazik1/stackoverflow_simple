require 'rails_helper'

feature 'User can create answer', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create the answer
" do

  describe 'Authenticated user' do
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

    scenario 'creates an answer' do
      fill_in 'answer[body]', with: 'Answer text'
      click_on 'Создать'

      expect(page).to have_content 'Ответ успешно создан'
      expect(page).to have_content 'Answer text'
    end

    scenario 'creates an answer with errors' do
      click_on 'Создать'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unathenticated user' do
    scenario 'cannot create an answer' do
      create(:question)

      visit questions_path
      click_on 'Открыть'

      expect(page).to_not have_content 'Создать'
    end
  end
end

