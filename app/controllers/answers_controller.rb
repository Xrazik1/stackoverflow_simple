class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  expose :user,                   ->{ current_user }
  expose :answer, find: ->(id, scope){ scope.with_attached_files.find(id) },
                  build:        ->(answer_params){ user.answers.new(answer_params) }
  expose :question

  def create
    answer.question = question
    answer.save
  end

  def update
    if user&.author_of?(answer)
      @question = answer.question

      if answer.files
        answer.files.attach(answer_params[:files])
        answer.update(answer_params.except(:files))
      else
        answer.update(answer_params)
      end

      flash[:success] = "Ответ успешно изменён"
    else
      flash[:error] = "Вы не можете изменить чужой ответ"
    end
  end

  def destroy
    if user&.author_of?(answer)
      @question = answer.question
      answer.destroy

      flash[:success] = "Ответ успешно удалён"
    else
      flash[:error] = "Вы не можете удалить чужой ответ"
    end
  end

  def set_best
    @question = answer.question

    if user&.author_of?(@question)
      answer.make_best
    else
      flash[:error] = "Вы не можете сделать лучшим чужой ответ"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
