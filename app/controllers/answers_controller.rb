class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  expose :answers,  -> { Answer.all }
  expose :question, -> { Question.find(params[:question_id] || params[:id]) }

  def create
    if answer.save
      flash[:success] = 'Ответ успешно создан'
      redirect_to question_path(question)
    else
      render 'questions/show', locals: {answer: answer}
    end
  end

  def update
    flash.now[:success] = 'Ответ успешно изменён' if answer.update(answer_params)
    render template: 'questions/show', locals: {answer: answer}
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
