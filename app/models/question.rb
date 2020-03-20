class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :user

  validates :title, :body, presence: true
end
