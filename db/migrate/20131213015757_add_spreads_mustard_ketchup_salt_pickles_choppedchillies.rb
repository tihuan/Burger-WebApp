class AddSpreadsMustardKetchupSaltPicklesChoppedchillies < ActiveRecord::Migration
  def change
  	add_column :burgers, :spread, :text
	add_column :burgers, :mustard, :text
	add_column :burgers, :ketchup, :text
	add_column :burgers, :extrasalt, :text
	add_column :burgers, :pickles, :text
	add_column :burgers, :chopchillies, :text
  end
end
