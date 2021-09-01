class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title,null: false
      t.text :description,null: false 
      t.bigint :user_id,null: false
    end
    add_index :movies,:user_id
  end
end
