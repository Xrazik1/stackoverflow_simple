require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { answer.question }

  describe 'POST #create' do
    let(:user) { create(:user) }

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
        expect{response}.to change(question.answers, :count).by(0)
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end
  end
end
