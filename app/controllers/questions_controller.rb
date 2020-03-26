class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question,  -> { params[:question] ? user.questions.new(question_params) : Question.new }
  expose :questions, -> { Question.all }
  expose :answers,   -> { question.answers }
  expose :user,      -> { current_user }

  def create
    if question.save
      flash[:success] = 'Вопрос успешно создан'
      redirect_to(questions_path)
    else
      render(:index)
    end
  end

  def update
    question.update(question_params) ? redirect_to(question_path(question)) : render(:edit)
  end

  def destroy
    question = Question.find(params[:id])

    if user&.author_of? question
      question.destroy
      flash[:success] = 'Вопрос успешно удалён'
    else
      flash[:danger] = 'Вы не можете удалить чужой вопрос'
    end

    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
