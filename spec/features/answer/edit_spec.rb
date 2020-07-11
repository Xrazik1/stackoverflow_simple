require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      login user
      visit question_path(question)
    end

    describe 'Author' do
      before { click_on 'Edit' }

      scenario 'edits his answer', js: true do
        within '.answers' do
          fill_in 'answer[body]', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
        end
      end

      scenario "edits answers's attached files", js: true do
        within ".answer" do
          attach_file 'Файлы', %W(#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb)
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edit his answer with errors', js: true do
        within '.answers' do
          fill_in 'answer[body]', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  given!(:stranger) { create(:user) }

  describe 'Stranger' do
    before do
      login stranger
      visit question_path(question)
    end

    scenario "tries to edit other user's answer", js: true do
      within '.answers' do
        expect(page).to_not have_button "Edit"
        expect(page).to_not have_selector "textarea"
      end
    end
  end
end


