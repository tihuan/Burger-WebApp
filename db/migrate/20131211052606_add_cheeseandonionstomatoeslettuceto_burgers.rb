class AddCheeseandonionstomatoeslettucetoBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :coldcheese, :text
	add_column :burgers, :meltcheese, :text
	add_column :burgers, :rawwholeonions, :text
	add_column :burgers, :rawchoponions, :text
	add_column :burgers, :grillwholeonions, :text
	add_column :burgers, :grillchoponions, :text
  end
end
