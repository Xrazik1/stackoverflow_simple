class ChangeAnswersRemoveCorrect < ActiveRecord::Migration[6.0]
  remove_column :answers, :correct
end
