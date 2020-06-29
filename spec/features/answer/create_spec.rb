require 'rails_helper'

feature 'User can create answer', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create the answer
" do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
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
      visit question_path(question)
      expect(page).to_not have_button 'Создать'
    end
  end
end

