class AddCommandsToRooms < ActiveRecord::Migration
  def change
  	add_column :rooms, :commands, :string
  end
end
