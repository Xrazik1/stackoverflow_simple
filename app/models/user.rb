class User < ApplicationRecord
  has_many :questions
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of? object
    case object.class.name
    when 'Question'
      questions.include? object
    when 'Answer'
      answers.include? object
    end
  end
end
