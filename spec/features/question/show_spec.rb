require 'rails_helper'

feature 'User can read questions', "
  In order to ask question
  I'd like to be able to read questions
" do

  given!(:question) { create(:question) }
  background { visit questions_path }

  scenario 'user can see the list of questions' do
    expect(page).to have_content question.title
  end

  scenario 'user can open question' do
    expect(page).to have_button 'Открыть'
    click_on 'Открыть'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end

