class RenamePosterIdToPostIdInRatings < ActiveRecord::Migration[5.2]
  def change
    rename_column :ratings,:poster_id,:post_id
  end
end
