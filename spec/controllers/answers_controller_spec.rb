require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  describe 'POST #create' do
    context 'Authenticated user' do

      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post(:create, params: { question_id: question, answer: attributes_for(:answer) })}.to change(question.answers, :count).by(1)
        end

        it 'redirects to answers' do
          expect(post(:create, params: { question_id: question, answer: attributes_for(:answer) })).to redirect_to question_answers_path
        end
      end

      context 'with invalid attributes' do
        before { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

        it 'does not save a new answer in the database' do
          expect{response}.to_not change(question.answers, :count)
        end

        it 'renders question show template' do
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Unaunthenticated user' do
      before { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the answer' do
        expect{response}.to change(question.answers, :count).by(0)
      end

      it 'redirects to login path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do

      before { login(user) }

      context 'Author' do
        it 'deletes the question' do
          expect{delete :destroy, params: { id: answer }}.to change(Answer, :count).by(-1)
        end

        it 'redirects to index' do
          expect(delete :destroy, params: { id: answer }).to redirect_to question_answers_path(question)
        end
      end

      context 'Stranger' do
        let(:another_user) { create(:user) }

        before { login(another_user) }

        it 'does not delete the answer' do
          expect{delete :destroy, params: { id: answer }}.to change(Answer, :count).by(0)
        end

        it 'redirects to index' do
          expect(delete :destroy, params: { id: answer }).to redirect_to question_answers_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete the answer' do
        expect{delete :destroy, params: { id: answer }}.to change(Answer, :count).by(0)
      end

      it 'redirects to login path' do
        expect(delete :destroy, params: { id: answer }).to redirect_to new_user_session_path
      end
    end
  end
end
