require 'rails_helper'

feature 'User can mark the answer as best', "
  In order to remember answer
  As an author of question
  I'd like to be able to mark the answer as best
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Unauthenticated user can not mark best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Выбрать ответ как лучший'
  end

  describe 'Authenticated user' do
    describe 'Author' do
      before do
        login user
        visit question_path(question)
      end

      scenario 'marks answer as best', js: true do
        find_link("Выбрать ответ как лучший", match: :first).click
        expect(page).to have_content 'Лучший ответ'
      end

      scenario 'cannot mark more than one answer as best', js: true do
        find_link("Выбрать ответ как лучший", match: :first).click
        find_link("Выбрать ответ как лучший", match: :first).click
        expect(page).to have_content('Лучший ответ', count: 1)
      end
    end

    given!(:stranger) { create(:user) }

    describe 'Stranger' do
      scenario "cannot mark other user's answer as best" do
        login stranger
        visit question_path(question)

        expect(page).to_not have_link 'Выбрать ответ как лучший'
      end
    end
  end
end



