class AnswersAddBestFlag < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best_flag, :boolean, default: false, null: false
  end
end
