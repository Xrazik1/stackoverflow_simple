require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 5, question: question) }

  describe 'Flag constraint validation' do
    it 'should be truthy if best answers less than one' do
      answer.best_flag = true
      expect(answer).to be_valid
    end

    it 'should be falsey if best answers more than one' do
      answers.first.update(best_flag: true)
      answers.last.update(best_flag: true)

      expect(answers.last).to_not be_valid
    end
  end

  describe 'make_best method' do
    it 'should make answer best' do
      answer.make_best
      expect(answer.best_flag).to be_truthy
    end

    it 'should remove best_flag from other answers' do
      question.answers.first.update(best_flag: true)
      question.answers.last.make_best

      expect(question.answers.first.best_flag).to be_falsey
    end

    let!(:another_question) { create(:question, user: user) }
    let!(:another_answer) { create(:answer, question: another_question) }

    it 'should not remove best_flag from other question answers' do
      another_question.answers.first.make_best
      question.answers.first.make_best

      expect(another_question.answers.first.best_flag).to be_truthy
      expect(question.answers.first.best_flag).to be_truthy
    end
  end

  describe 'by_best scope' do
    it 'should return a list of answers sorted by best flag' do
      answer = answers.last
      answer.make_best
      sorted = question.answers.by_best
      expect(sorted.first.best_flag).to be_truthy
    end
  end
end
