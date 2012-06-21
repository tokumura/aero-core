class RemovePictcodeFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :pictcode
  end

  def self.down
    add_column :products, :pictcode, :text
  end
end
