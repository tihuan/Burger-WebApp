class AddFrystyleBeefcountToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :frystyle, :text
  	add_column :burgers, :beefcount, :text
  end
end
