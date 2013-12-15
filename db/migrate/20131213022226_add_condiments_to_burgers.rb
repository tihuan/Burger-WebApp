class AddCondimentsToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :condiments, :text
  end
end
