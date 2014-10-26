class SetBurgerCodeDefault < ActiveRecord::Migration
  def change
    change_column :burgers, :code, :string, default: ''
  end
end
