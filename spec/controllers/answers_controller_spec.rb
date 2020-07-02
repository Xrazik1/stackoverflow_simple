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

        it "assigns the answer to correct user" do
          post(:create, params: { question_id: question, answer: attributes_for(:answer) })
          expect(assigns(:exposed_answer).user_id).to eq user.id
        end

        it 'redirects to question' do
          expect(post(:create, params: { question_id: question, answer: attributes_for(:answer) })).to redirect_to question_path(question)
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
        expect{response}.to_not change(question.answers, :count)
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
        it 'deletes his question' do
          expect{delete :destroy, params: { id: answer }}.to change(Answer, :count).by(-1)
        end

        it 'redirects to question' do
          expect(delete :destroy, params: { id: answer }).to redirect_to question_path(question)
        end
      end

      context 'Stranger' do
        let(:another_user) { create(:user) }

        before { login(another_user) }

        it 'cannot delete the answer' do
          expect{delete :destroy, params: { id: answer }}.to_not change(Answer, :count)
        end

        it 'redirects to question' do
          expect(delete :destroy, params: { id: answer }).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete the answer' do
        expect{delete :destroy, params: { id: answer }}.to_not change(Answer, :count)
      end

      it 'redirects to login path' do
        expect(delete :destroy, params: { id: answer }).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before{ login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        expect(patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'doesnt change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end


  describe 'PATCH #set_best_answer' do
    before{ login(user) }

    context 'with valid attributes' do
      it 'saves best answer' do
        patch :set_best_answer, params: { id: answer, answer: { best_flag: true } }, format: :js
        answer.reload
        expect(answer.best_flag).to be_truthy
      end

      it 'renders set_best_answer view' do
        expect(patch :set_best_answer, params: { id: answer, answer: { best_flag: true } }, format: :js).to render_template :set_best_answer
      end
    end

    context 'with invalid attributes' do
      it 'doesnt change best answer if best_flag is nil' do
        expect do
          patch :set_best_answer, params: { id: answer, answer: { best_flag: nil } }, format: :js
        end.to_not change(answer, :best_flag)
      end

      it 'doesnt save more than one best answer' do
        patch :set_best_answer, params: { id: answers.first, answer: { best_flag: true } }, format: :js
        patch :set_best_answer, params: { id: answers.last, answer: { best_flag: true } }, format: :js

        expect(answers.last.best_flag).to be_falsey
      end
    end
  end
end
