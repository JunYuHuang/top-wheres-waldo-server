class CreateScores < ActiveRecord::Migration[7.0]
  def change
    create_table :scores do |t|
      t.string :player_name
      t.integer :start_in_ms
      t.integer :end_in_ms
      t.integer :photo_id

      t.timestamps
    end

    add_foreign_key :scores, :photos
  end
end
