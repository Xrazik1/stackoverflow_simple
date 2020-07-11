require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my question
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

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
      scenario 'edits his question', js: true do
        within '.question' do
          click_on 'Edit'

          fill_in 'question[body]', with: 'edited question body'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question body'
          expect(page.find(".edit_question")[:class].include?("hidden")).to be_truthy
        end
      end

      scenario 'edit his answer with errors', js: true do
        within '.question' do
          click_on 'Edit'
          fill_in 'question[body]', with: ''
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

    scenario "tries to edit other user's question", js: true do
      within '.question' do
        expect(page).to_not have_button "Edit"
        expect(page).to_not have_selector "textarea"
      end
    end
  end
end


