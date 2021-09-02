class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.bigint :user_id,null: false
      t.bigint :poster_id,null: false 
      t.string :rating,null:false 
    end
    add_index :ratings, [:user_id,:poster_id],unique: true
    add_index :ratings, :poster_id 
  end
end
