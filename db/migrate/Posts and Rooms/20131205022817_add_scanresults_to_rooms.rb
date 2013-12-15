class AddScanresultsToRooms < ActiveRecord::Migration
  def change
  	add_column :rooms, :scanresults, :string
  end
end
