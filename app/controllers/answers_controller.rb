class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  expose :user,                   ->{ current_user }
  expose :answer,   build:        ->(answer_params){ user.answers.new(answer_params) }
  expose :question

  def create
    answer.question = question
    answer.save
  end

  def update
    if user&.author_of?(answer)
      @question = answer.question
      answer.update(answer_params)
    end
  end

  def destroy
    if user&.author_of?(answer)
      @question = answer.question
      answer.destroy
    end
  end

  def set_best_answer
    @question = answer.question
    answer.make_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
