class User < ApplicationRecord
  has_many :questions
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def has_question? question
    questions.include? question
  end

  def has_answer? answer
    answers.include? answer
  end
end
