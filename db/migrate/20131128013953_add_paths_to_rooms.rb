class AddPathsToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :paths, :string
  end
end
