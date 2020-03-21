class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  expose :answers,  -> { Answer.all }
  expose :question, -> { Question.find(params[:question_id] || params[:id]) }
  expose :answer,   -> { params[:answer] ? user.answers.new(answer_params) : Answer.new }
  expose :user,     -> { current_user }

  def create
    if answer.save
      flash[:success] = 'Ответ успешно создан'
      redirect_to question_answers_path
    else
      render :index
    end
  end

  def destroy
    answer = user.answers.find(params[:id])
    answer.destroy

    flash[:success] = 'Ответ успешно удалён'
    redirect_to question_answers_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id).merge(question_id: question.id)
  end
end
