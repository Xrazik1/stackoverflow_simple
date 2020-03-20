class Answer < ApplicationRecord
  belongs_to :question
  has_one :user

  validates :body, presence: true

  def has_question? question
    questions.include? question
  end
end
