class AddLettuceToBurger < ActiveRecord::Migration
  def change
  	add_column :burgers, :lettuce, :string
  end
end
