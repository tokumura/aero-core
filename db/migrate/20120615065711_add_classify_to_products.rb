class AddClassifyToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :classify, :string
  end

  def self.down
    remove_column :products, :classify
  end
end
