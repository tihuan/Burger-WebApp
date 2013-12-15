class AddSumsToAttributes < ActiveRecord::Migration
  def change
  	add_column :burgers, :sumbeef, :integer
	add_column :burgers, :sumcheese, :integer
	add_column :burgers, :sumonions, :integer
  end
end
