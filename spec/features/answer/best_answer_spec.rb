require 'rails_helper'

feature 'User can mark the answer as best', "
  In order to remember answer
  As an author of question
  I'd like to be able to mark the answer as best
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not mark best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Выбрать ответ как лучший'
  end

  describe 'Authenticated user' do
    before do
      login user
      visit question_path(question)
    end

    describe 'Author' do
      scenario 'marks answer as best', js: true do
        click_on 'Выбрать ответ как лучший'
        expect(page).to have_content 'Лучший ответ'
      end
    end
  end

  given!(:stranger) { create(:user) }

  describe 'Stranger' do
    scenario "tries to mark other user's answer as best", js: true do
      login stranger
      visit question_path(question)

      expect(page).to_not have_link 'Выбрать ответ как лучший'
    end
  end
end



