class AddPictcodeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :pictcode, :text
  end

  def self.down
    remove_column :products, :pictcode
  end
end
