class UpdateScores < ActiveRecord::Migration[7.0]
  def change
    add_column :scores, :run_length_in_ms, :integer
    remove_column :scores, :start_in_ms, :integer
    remove_column :scores, :end_in_ms, :integer
  end
end
