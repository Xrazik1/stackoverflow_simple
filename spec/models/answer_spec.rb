require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Flag constraint validation' do
    it 'should be truthy if best answers less than one' do
      answer.best_flag = true
      expect(answer).to be_valid
    end

    # Не могу никак понять почему здесь все ответы валидные
    it 'should be falsey if best answers more than one' do
      answers.first.best_flag = true
      answers.last.best_flag = true

      answers.first.save

      expect(answers.last).to_not be_valid
    end
  end

  describe 'make_best method' do
    it 'should make answer best' do
      answer.make_best
      expect(answer.best_flag).to be_truthy
    end
  end
end
