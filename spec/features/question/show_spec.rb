require 'rails_helper'

feature 'User can read questions', "
  In order to ask question
  I'd like to be able to read questions
" do

  given!(:questions) { create_list(:question, 2) }
  background { visit questions_path }

  scenario 'user can see the list of questions' do
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end

  scenario 'user can open question' do
    expect(page).to have_button 'Открыть'
    click_button('Открыть', match: :first)

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.first.body
  end
end

