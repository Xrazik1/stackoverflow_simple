require 'rails_helper'

feature 'User can log out', "
  As an authenticated user
  I'd like to be able to log out
" do

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    before { login(user) }

    scenario 'tries to log out' do
      click_on 'Выйти'

      expect(page).to_not have_content 'Выйти'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to log out' do
      visit questions_path
      expect(page).to_not have_content 'Выйти'
    end
  end
end
