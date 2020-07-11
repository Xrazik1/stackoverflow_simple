require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let(:answers) { create_list(:answer, 2, question: question) }

  describe 'POST #create' do
    context 'Authenticated user' do

      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post(:create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js)}.to change(question.answers, :count).by(1)
        end

        it "assigns the answer to correct user" do
          post(:create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js)
          expect(assigns(:exposed_answer).user_id).to eq user.id
        end

        it 'renders create template' do
          expect(post(:create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js)).to render_template :create
        end
      end

      context 'with invalid attributes' do
        before { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not save a new answer in the database' do
          expect{response}.to_not change(question.answers, :count)
        end

        it 'renders create template' do
          expect(response).to render_template :create
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
          expect{delete :destroy, params: { id: answer }, format: :js}.to change(Answer, :count).by(-1)
        end
      end

      context 'Stranger' do
        let(:another_user) { create(:user) }

        before { login(another_user) }

        it 'cannot delete the answer' do
          expect{delete :destroy, params: { id: answer }, format: :js}.to_not change(Answer, :count)
        end

        it 'renders destroy view with alerts' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
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
    context 'Authenticated user' do
      before { login(user) }

      context 'Author' do
        context 'with valid attributes' do
          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'appends files to the answer' do
            patch :update, params: { id: answer, answer: {
                files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")] }
            }, format: :js
            patch :update, params: { id: answer, answer: {
                files: [fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")] }
            }, format: :js

            expect(answer.files.count).to eq 2
          end

          it 'renders update view' do
            expect(patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'cannot change answer attributes' do
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

      context 'Stranger' do
        let(:another_user) { create(:user) }
        before { login(another_user) }

        it 'cannot change the answer' do
          expect do
            patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view with alerts' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do
      it 'cannot change the answer' do
        expect do
          patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end

  describe 'PATCH #set_best' do
    before{ login(user) }

    context 'Author' do
      it 'sets best answer' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best?).to be_truthy
      end

      it 'renders set_best view' do
        expect(patch :set_best, params: { id: answer }, format: :js).to render_template :set_best
      end

      it 'cannot save more than one best answer' do
        patch :set_best, params: { id: answers.first }, format: :js
        patch :set_best, params: { id: answers.last }, format: :js

        expect(answers.last.best?).to be_falsey
      end
    end

    context 'Stranger' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'cannot set best answer' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best?).to be_falsey
      end

      it 'renders set_best view with alerts' do
        expect(patch :set_best, params: { id: answer }, format: :js).to render_template :set_best
      end
    end
  end
end
