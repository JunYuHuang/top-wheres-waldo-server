class CreatePhotoObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :photo_objects do |t|
      t.string :name
      t.string :image_name
      t.integer :top_left_x
      t.integer :top_left_y
      t.integer :bot_right_x
      t.integer :bot_right_y
      t.integer :photo_id

      t.timestamps
    end

    add_foreign_key :photo_objects, :photos
  end
end
