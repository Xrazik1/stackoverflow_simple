class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions,       ->{ Question.all }
  expose :user,            ->{ current_user }
  expose :answer,   build: ->(answer_params){ user.answers.new(answer_params) }, id: :answer_id
  expose :question, build: ->(question_params){ user.questions.new(question_params) }

  def create
    if question.save
      flash[:success] = 'Вопрос успешно создан'
      redirect_to questions_path
    else
      render :index
    end
  end

  def update
    if user&.author_of?(question)
      question.update(question_params)
      flash[:success] = 'Вопрос успешно изменён'
    else
      flash[:error] = 'Вы не можете изменить чужой ответ'
    end
  end

  def destroy
    if user&.author_of?(question)
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
