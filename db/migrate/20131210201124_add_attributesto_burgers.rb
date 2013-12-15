class AddAttributestoBurgers < ActiveRecord::Migration
  def change
	add_column :burgers, :buns, :string
	add_column :burgers, :patties, :string
	add_column :burgers, :cheese, :string
	add_column :burgers, :onions, :string
	add_column :burgers, :tomatoes, :string
	add_column :burgers, :lettuce, :string
	add_column :burgers, :spreads, :string
	add_column :burgers, :others, :string
	add_column :burgers, :cutinhalf, :string
  end
end
