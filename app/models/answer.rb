class Answer < ApplicationRecord
  belongs_to :question
  has_one :user

  validates :body, presence: true
end
