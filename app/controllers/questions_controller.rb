class QuestionsController < ApplicationController
  expose :question
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }

  def index; end

  def show; end

  def new; end

  def create
    question.save ? redirect_to(questions_path) : render(:new)
  end

  def update
    question.update(question_params) ? redirect_to(question_path(question)) : render(:edit)
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
