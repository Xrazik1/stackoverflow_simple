require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password }
  it { should have_many :answers }
  it { should have_many :questions }

  describe 'authors checking method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'checks that a question belongs to user' do
      expect(user).to be_author_of(question)
    end

    it 'checks that a question does not belong to user' do
      expect(user).to_not be_author_of(create(:question))
    end
  end
end
