class ChangeIndexFromEmailToUsernameOnUsers < ActiveRecord::Migration
  def self.up
    remove_index :users, :email
    add_index :users, :username
  end

  def self.down
    add_index :users, :email
    remove_index :users, :username
  end
end
