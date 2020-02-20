require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { answer.question }

  describe 'POST #create' do
    it 'renders question show template' do
      expect(post(:create, params: { question_id: question, answer: attributes_for(:answer) })).to redirect_to question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post(:create, params: { question_id: question, answer: attributes_for(:answer) })}.to change(question.answers, :count).by(1)
      end

      it 'flashes a success message' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response.request.flash[:success]).to_not be_nil
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to change(question.answers, :count).by(0)
      end

      it 'renders question show template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response.request.flash[:success]).to be_nil
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } } }

      it 'changes answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
        expect(answer.question).to eq question
      end

      it 'redirects to question' do
        expect(response).to redirect_to question
      end
    end
  end
end
