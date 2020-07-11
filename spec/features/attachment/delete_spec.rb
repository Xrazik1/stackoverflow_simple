require 'rails_helper'

feature 'User can delete attachment', "
  In order to manage info
  As an authenticated user
  I'd like to be able to delete it
" do

  given(:user) { create(:user) }
  given!(:question_with_files) { create(:question_with_files, user: user) }
  given!(:file) { question_with_files.files.first }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question_with_files)
    end

    context 'Author' do
      scenario "deletes question's attachment" do
        within ".question .attachments" do
          click_on 'Удалить'
        end

        expect(page).to_not have_content file.filename.to_s
      end
    end
  end

  describe 'Unathenticated user' do
    scenario "cannot delete someone's attachment" do
      visit question_path(question_with_files)

      expect(page).to_not have_button 'Удалить'
    end
  end

  describe 'Stranger' do
    given(:stranger) { create(:user) }

    scenario "cannot delete someone's attachment", js: true do
      login(stranger)
      visit question_path(question_with_files)
      expect(page).to_not have_button 'Удалить'
    end
  end
end

