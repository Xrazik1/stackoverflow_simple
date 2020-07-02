class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def answers_by_best
    answers.order(best_flag: :desc)
  end
end
