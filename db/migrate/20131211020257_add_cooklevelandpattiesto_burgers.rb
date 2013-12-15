class AddCooklevelandpattiestoBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :cooklevel, :text
	add_column :burgers, :heavymustardbeef, :text
	add_column :burgers, :normalmustardbeef, :text
	add_column :burgers, :normalbeef, :text
	add_column :burgers, :nosaltbeef, :text
  end
end
