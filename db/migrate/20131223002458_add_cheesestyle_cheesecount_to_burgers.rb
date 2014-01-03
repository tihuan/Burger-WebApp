class AddCheesestyleCheesecountToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :cheesestyle, :text
  	add_column :burgers, :cheesecount, :text
  end
end
