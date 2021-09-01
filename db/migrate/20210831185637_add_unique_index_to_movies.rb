class AddUniqueIndexToMovies < ActiveRecord::Migration[5.2]
  def change
    add_index :movies,[:title,:poster_id], unique: true
  end
end
