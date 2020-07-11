require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user_with_questions) }
  let(:question) { user.questions.first }

  describe 'GET #index' do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    context 'Authenticated user' do
      let(:user) { create(:user) }

      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it "assigns the question to correct user" do
          post :create, params: { question: attributes_for(:question) }
          expect(assigns(:exposed_question).user_id).to eq user.id
        end

        it 'redirects to index view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:exposed_questions)
        end
      end

      context 'with invalid attributes' do
        it "doesn't save the question" do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :index
        end
      end
    end

    context 'Unauthenticated user' do
      before { post :create, params: { question: attributes_for(:question, :invalid) }  }

      it "doesn't save the question" do
        expect {response}.to_not change(Question, :count)
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
          expect { question.destroy }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'Stranger' do
        let(:another_user) { create(:user) }

        before do
          login(another_user)
          delete :destroy, params: { id: question }
        end

        it 'does not delete the question' do
          expect{response}.to_not change(Question, :count)
        end

        it 'redirects to index' do
          expect(response).to redirect_to questions_path
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete the question' do
        expect { question.destroy }.to_not change(Question, :count)
      end

      it 'redirects to login path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }

      context 'Author' do
        context 'with valid attributes' do
          it 'changes question attributes' do
            patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
            question.reload
            expect(question.body).to eq 'new body'
          end

          it 'appends files to the answer' do
            patch :update, params: { id: question, question: {
                files: [ Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
            }, format: :js
            patch :update, params: { id: question, question: {
                files: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb")] }
            }, format: :js

            expect(question.files.count).to eq 2
          end

          it 'renders update view' do
            expect(patch :update, params: { id: question, question: { body: 'new body' } }, format: :js).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'cannot change question attributes' do
            expect do
              patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
            end.to_not change(question, :body)
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end
      end

      context 'Stranger' do
        let(:another_user) { create(:user) }
        before { login(another_user) }

        it 'cannot change the question' do
          expect do
            patch :update, params: { id: question, question: {body: 'new body'} }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update view with alerts' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do
      it 'cannot change the question' do
        expect do
          patch :update, params: { id: question, question: {body: 'new body'} }, format: :js
        end.to_not change(question, :body)
      end

      it 'redirects to login path' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
