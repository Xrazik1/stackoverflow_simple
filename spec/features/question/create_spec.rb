require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { login(user) }

    scenario 'asks a question' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'Question text'
      click_on 'Создать'

      expect(page).to have_content 'Вопрос успешно создан'
      expect(page).to have_content 'Test question'
    end

    scenario 'asks a question with errors' do
      click_on 'Создать'
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Unathenticated user' do
    scenario 'cannot ask a question' do
      visit questions_path
      expect(page).to_not have_button 'Создать'
    end
  end
end
