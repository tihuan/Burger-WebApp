class AddResultAndCodeToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :result, :text
  	add_column :burgers, :code, :text
  end
end
