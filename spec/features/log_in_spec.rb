require 'rails_helper'

feature 'User can log in', "
  In order to ask questions
  As an unathenticated user
  I'd like to be able to log in
" do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Registered user tries to log in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to log in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '1234567'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
