class ChangeColumnEmailToNullFalse < ActiveRecord::Migration
  def self.up
    change_column :users, :email, :string, :null => false
  end

  def self.down
    change_column :users, :email, :string, :null => true
  end
end
