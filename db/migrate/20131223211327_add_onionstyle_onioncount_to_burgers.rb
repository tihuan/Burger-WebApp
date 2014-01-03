class AddOnionstyleOnioncountToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :onionstyle, :text
  	add_column :burgers, :onioncount, :text
  end
end
