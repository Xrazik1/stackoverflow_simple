require 'rails_helper'

feature 'User can log out', "
  As an authenticated user
  I'd like to be able to log out
" do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Выйти'

    expect(page).to_not have_content 'Выйти'
  end

  scenario 'Unauthenticated user tries to log out' do
    visit questions_path
    expect(page).to_not have_content 'Выйти'
  end
end
