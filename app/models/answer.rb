class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validate :best_flag_constraint_validation

  scope :by_best, -> { order(best_flag: :desc) }

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.where(best_flag: true).update_all(best_flag: false)
      self.update!(best_flag: true)
    end

    self
  end

  def best_flag_constraint_validation
    if question
      errors.add(:base, 'Only one best flag can be truthy') if ([] << question.answers.find_by(best_flag: true)).length > 1
    end
  end
end
