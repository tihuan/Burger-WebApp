class AddOnion1234ToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :onion1, :text
  	add_column :burgers, :onion2, :text
  	add_column :burgers, :onion3, :text
  	add_column :burgers, :onion4, :text
  end
end
