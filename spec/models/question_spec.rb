require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 5, question: question) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :answers }
  it { should belong_to :user }

  describe 'answers_by_best method' do
    it 'should return a list of answers sorted by best flag' do
      answer = answers.last
      answer.make_best
      sorted = question.answers_by_best
      expect(sorted.first.best_flag).to be_truthy
    end
  end
end
