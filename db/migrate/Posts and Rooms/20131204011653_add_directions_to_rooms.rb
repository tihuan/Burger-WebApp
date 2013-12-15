class AddDirectionsToRooms < ActiveRecord::Migration
  def change
  	add_column :rooms, :directions, :string
  end
end
