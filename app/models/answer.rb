class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validate :best_constraint_validation

  scope :by_best, -> { order(best: :desc) }

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end

    self
  end

  def best_constraint_validation
    if question
      errors.add(:base, 'Only one best flag can be truthy') if question.answers.select(:best).where(best: true).count > 1
    end
  end
end
