class AddPictToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :pict, :string
  end

  def self.down
    remove_column :products, :pict
  end
end
