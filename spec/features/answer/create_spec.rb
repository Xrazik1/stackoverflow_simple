require 'rails_helper'

feature 'User can create answer', "
  In order to share my knowledge
  As an authenticated user
  I'd like to be able to create the answer
" do

  given(:user) { create(:user_with_questions) }
  given!(:question) { user.questions.first }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'creates an answer', js: true do
      fill_in 'answer[body]', with: 'Answer text'
      click_on 'Создать'

      expect(page).to have_content 'Answer text'
    end

    scenario 'asks an answers with attached files', js: true do
      within ".new_answer" do
        fill_in 'answer[body]', with: 'Answer text'

        attach_file 'Файлы', %W(#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb)
        click_on 'Создать'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates an answer with errors', js: true do
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

