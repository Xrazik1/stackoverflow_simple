require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user_with_answers) }
  let(:answer) { user.answers.first }
  let(:question) { answer.question }

  before { login(user) }

  describe 'POST #create' do
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
        expect{response}.to change(question.answers, :count).by(0)
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the question' do
      expect { answer.destroy }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_answers_path(question)
    end
  end
end
