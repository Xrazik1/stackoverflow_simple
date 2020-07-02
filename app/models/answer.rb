class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validate :best_flag_constraint_validation

  def make_best
    best_answers = ([] << question.answers.find_by(best_flag: true)).compact

    puts best_answers

    if best_answers
      best_answers.each do |answer|
        answer.best_flag = false
        answer.save
      end
    end

    self.best_flag = true
    self.save
    self
  end

  def best_flag_constraint_validation
    if question
      errors.add(:base, 'Only one best flag can be truthy') if ([] << question.answers.find_by(best_flag: true)).length > 1
    end
  end
end
