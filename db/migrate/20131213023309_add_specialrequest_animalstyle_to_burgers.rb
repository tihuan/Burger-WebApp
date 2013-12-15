class AddSpecialrequestAnimalstyleToBurgers < ActiveRecord::Migration
  def change
  	add_column :burgers, :specialrequests, :text
  	add_column :burgers, :animalstyle, :text
  end
end
