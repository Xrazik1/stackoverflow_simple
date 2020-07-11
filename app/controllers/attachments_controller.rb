class AttachmentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :user,            ->{ current_user }
  expose :attachment,      -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    if user&.author_of?(attachment.record)
      attachment.purge
      flash[:success] = 'Файл успешно удалён'
    else
      flash[:danger] = 'Вы не можете удалить чужой файл'
    end

    if attachment.record.instance_of? Question
      redirect_to attachment.record
    else
      redirect_to attachment.record.question
    end
  end
end

