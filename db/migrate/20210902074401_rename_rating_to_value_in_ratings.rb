class RenameRatingToValueInRatings < ActiveRecord::Migration[5.2]
  def change
    rename_column :ratings,:rating,:value
  end
end
