require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password }

  describe 'authors checking method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }

    it 'checks that a question belongs to user' do
      expect(user.author_of? question).to be_truthy
    end

    it 'checks that a question does not belong to user' do
      expect(user.author_of? create(:question)).to be_falsey
    end

    it 'checks that an answer belongs to user' do
      expect(user.author_of? answer).to be_truthy
    end

    it 'checks that a question does not belong to user' do
      expect(user.author_of? create(:answer)).to be_falsey
    end
  end
end
