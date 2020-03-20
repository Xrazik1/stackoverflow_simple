class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question,  -> { params[:question] ? user.questions.new(question_params) : Question.new }
  expose :questions, -> { Question.all }
  expose :answers,   -> { question.answers }
  expose :answer,    -> { params[:answer_id] ? Answer.find(params[:id]) : question.answers.new }

  def index; end

  def show; end

  def new; end

  def create
    question.save ? redirect_to(questions_path) : render(:index)
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
