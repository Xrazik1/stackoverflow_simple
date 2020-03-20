require 'rails_helper'

feature 'User can sign up', "
  As a unregistered user
  I'd like to be able to sign up
" do

  describe 'Unregistered user' do
    before { visit new_user_registration_path }

    scenario 'tries to sign up' do
      fill_in 'Email', with: '123456@mail.ru'
      fill_in 'Password', with: '1234567'
      fill_in 'Password confirmation', with: '1234567'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with errors' do
      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
    end
  end

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign up' do
      visit new_user_registration_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end

