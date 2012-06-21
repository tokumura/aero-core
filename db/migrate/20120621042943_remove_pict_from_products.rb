class RemovePictFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :pict
  end

  def self.down
    add_column :products, :pict, :string
  end
end
