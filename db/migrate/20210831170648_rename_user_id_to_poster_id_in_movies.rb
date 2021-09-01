class RenameUserIdToPosterIdInMovies < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies,:user_id,:poster_id
  end
end
