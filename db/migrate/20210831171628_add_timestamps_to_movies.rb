class AddTimestampsToMovies < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :movies
  end
end
