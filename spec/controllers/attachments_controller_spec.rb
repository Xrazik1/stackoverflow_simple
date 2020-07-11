require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user_with_questions) }
  let(:question_with_files) { create(:question_with_files, user: user) }
  let!(:file) { question_with_files.files.first }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'Author' do
        it 'deletes the file' do
          expect { delete :destroy, params: { id: file }}.to change(question_with_files.files, :count).by(-1)
        end

        it 'redirects to question' do
          delete :destroy, params: { id: file }
          expect(response).to redirect_to question_path question_with_files
        end
      end

      context 'Stranger' do
        let(:another_user) { create(:user) }

        before do
          login(another_user)
          delete :destroy, params: { id: file }
        end

        it 'does not delete the file' do
          expect{response}.to_not change(question_with_files.files, :count)
        end

        it 'redirects to question' do
          expect(response).to redirect_to question_path question_with_files
        end
      end
    end

    context 'Unauthenticated user' do
      before { delete :destroy, params: { id: file } }

      it 'does not delete the file' do
        expect{response}.to_not change(question_with_files.files, :count)
      end

      it 'redirects to question' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

