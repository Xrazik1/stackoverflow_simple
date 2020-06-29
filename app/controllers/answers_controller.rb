class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  expose :user,                   ->{ current_user }
  expose :answer,   build:        ->(answer_params){ user.answers.new(answer_params) }
  expose :question

  def create
    answer.question = question

    if answer.save
      flash[:success] = 'Ответ успешно создан'
      redirect_to question_path question
    else
      render 'questions/show'
    end
  end

  def destroy
    if user&.author_of?(answer)
      answer.destroy
      flash[:success] = 'Ответ успешно удалён'
    else
      flash[:danger] = 'Вы не можете удалить чужой ответ'
    end

    redirect_to question_path answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
